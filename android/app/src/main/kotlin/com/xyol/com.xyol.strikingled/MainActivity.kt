package com.xyol.strikingled

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.core.net.toUri

class MainActivity: FlutterActivity()
{
    private val channelSendEmail = "channelSendEmail"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelSendEmail).setMethodCallHandler {
                call, result ->
            if (call.method == "sendEmail") {
                val email = call.argument<String>("email")
                val subject = call.argument<String>("subject")
                val body = call.argument<String>("body")
                sendEmail(email, subject, body)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun sendEmail(email: String?, subject: String?, body: String?) {
        val intent = Intent(Intent.ACTION_SENDTO).apply {
            data = "mailto:".toUri()
            putExtra(Intent.EXTRA_EMAIL, arrayOf(email))
            putExtra(Intent.EXTRA_SUBJECT, subject)
            putExtra(Intent.EXTRA_TEXT, body)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        startActivity(intent)
    }
}
