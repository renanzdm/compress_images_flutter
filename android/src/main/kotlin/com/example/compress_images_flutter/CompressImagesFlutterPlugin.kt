package com.example.compress_images_flutter

import android.graphics.Bitmap
import android.graphics.Bitmap.CompressFormat
import android.graphics.BitmapFactory
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
            "compress_image" ->compressImage(call,result)
        }

    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)

    }

    private fun compressImage(call: MethodCall, result: Result) {
        val fileName: String = call.argument<String>("file")!!
        val quality: Int = call.argument<Int>("quality")!!

        val file = File(fileName)
        if (!file.exists()) {
            result.error("Arquivo nao existe", fileName, null)
            return
        }
        var bitmap = BitmapFactory.decodeFile(fileName)
        val output = ByteArrayOutputStream()
        bitmap = Bitmap.createScaledBitmap(
            bitmap, bitmap.width, bitmap.height, true
        )
        val newBmp = bitmap.copy(Bitmap.Config.RGB_565, false)
        CoroutineScope(context = Dispatchers.IO).launch {
            newBmp.compress(CompressFormat.JPEG, quality, output)
            withContext(Dispatchers.Main){
                try {
                    val outputFileName: String = File.createTempFile(getFilenameWithoutExtension(file),".jpg").path
                    val outputStream: OutputStream = FileOutputStream(outputFileName)
                    output.writeTo(outputStream)
                    result.success(outputFileName)
                } catch (e: FileNotFoundException) {
                    e.printStackTrace()
                    result.error("Arquivo Inexistente", fileName, e.printStackTrace())
                } catch (e: IOException) {
                    e.printStackTrace()
                    result.error("Error desconhecido", fileName, e.printStackTrace())
                }

            }

        }

    }
    private fun getFilenameWithoutExtension(file: File): String {
        val fileName = file.name
        return if (fileName.indexOf(".") > 0) {
            fileName.substring(0, fileName.lastIndexOf("."))
        } else {
            fileName
        }
    }


}

