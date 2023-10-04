package com.example.compress_images_flutter

import android.graphics.Bitmap
import android.graphics.Bitmap.CompressFormat
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.media.ExifInterface
import androidx.annotation.NonNull

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
    val CHANNEL_NAME: String = "compress_images_flutter"

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "compress_image" -> compressImage(call, result)
            "rotate_image" -> rotateImage(call, result)
        }

    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)

    }

    private fun compressImage(call: MethodCall, result: Result) {
        val fileName: String = call.argument<String>("file")!!
        val quality: Int = call.argument<Int>("quality")!!
        var error = ""
        val exifOld = ExifInterface(fileName)


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
        CoroutineScope(context = Dispatchers.Main).launch {
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
            if (error.isNotBlank()) {
                result.error("", "", error)
            } else {
                ExifInterface(fileName).setAttribute(
                    ExifInterface.TAG_ORIENTATION,
                    exifOld.getAttribute(ExifInterface.TAG_ORIENTATION)
                )
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
        CoroutineScope(context = Dispatchers.Main).launch {
            withContext(Dispatchers.IO) {
                val outputStream: OutputStream = FileOutputStream(fileName)
                bitmapRotate.compress(CompressFormat.JPEG, 100, output)
                output.writeTo(outputStream)
                outputStream.flush()
                outputStream.close()
            }
            ExifInterface(fileName).setAttribute(
                ExifInterface.TAG_ORIENTATION,
                exifOld.getAttribute(ExifInterface.TAG_ORIENTATION)
            )
            result.success(fileName)
        }
    }


}

