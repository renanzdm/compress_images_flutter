package com.example.compress_images_flutter

import android.graphics.Bitmap
import android.graphics.Bitmap.CompressFormat
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.media.ExifInterface
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.*

class CompressImagesFlutterPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private val channelName: String = "compress_images_flutter"
    private val mainScope: CoroutineScope = CoroutineScope(context = Dispatchers.Main)

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "compress_image" -> compressImage(call, result)
            "rotate_image" -> rotateImage(call, result)
        }

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)

    }

    private fun compressImage(call: MethodCall, result: Result) {
        val fileName: String = call.argument<String>("file")!!
        val quality: Int = call.argument<Int>("quality")!!
        var error: String? = null
        val oldExif = ExifInterface(fileName)


        val file = File(fileName)
        if (!file.exists()) {
            result.error("Arquivo nao existe", fileName, null)
            return
        }
        val bitmap = BitmapFactory.decodeFile(fileName)
        val output = ByteArrayOutputStream()
        Bitmap.createScaledBitmap(
            bitmap, bitmap.width, bitmap.height, true
        )
        mainScope.launch {
            bitmap.compress(CompressFormat.JPEG, quality, output)
            withContext(Dispatchers.IO) {
                try {
                    val outputStream: OutputStream = FileOutputStream(fileName)
                    output.writeTo(outputStream)
                    outputStream.flush()
                    outputStream.close()
                } catch (e: FileNotFoundException) {
                    error = e.message.toString()
                    e.printStackTrace()
                } catch (e: IOException) {
                    error = e.message.toString()
                    e.printStackTrace()
                }

            }
            if (error != null) {
                result.error("", "", error)
            } else {
                val newExif = ExifInterface(fileName)
                newExif.setAttribute(
                    ExifInterface.TAG_ORIENTATION,
                    oldExif.getAttribute(ExifInterface.TAG_ORIENTATION)
                )
                newExif.saveAttributes()
                result.success(fileName)
            }

        }

    }


    private fun rotateImage(call: MethodCall, result: Result) {
        val fileName: String = call.argument<String>("file")!!
        val degree: Double = call.argument<Double>("degree")!!
        val exifOld = ExifInterface(fileName)
        val bitmap = BitmapFactory.decodeFile(fileName)
        val output = ByteArrayOutputStream()
        val rotation = Matrix()
        rotation.postRotate(degree.toFloat())
        val bitmapRotate = Bitmap.createBitmap(
            bitmap, 0, 0, bitmap.width, bitmap.height, rotation, true
        )
        mainScope.launch {
            withContext(Dispatchers.IO) {
                val outputStream: OutputStream = FileOutputStream(fileName)
                bitmapRotate.compress(CompressFormat.JPEG, 100, output)
                output.writeTo(outputStream)
                outputStream.flush()
                outputStream.close()
            }
            result.success(fileName)
        }
    }


}

