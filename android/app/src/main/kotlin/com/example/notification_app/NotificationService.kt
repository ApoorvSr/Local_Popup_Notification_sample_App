package com.example.notification_app

import android.app.*
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import java.util.*

class NotificationService : Service() {

    override fun onCreate() {
        super.onCreate()
        startForeground(1, createNotification("Service Running"))

        // Schedule repeating notification daily
        Timer().schedule(object : TimerTask() {
            override fun run() {
                sendNotification()
            }
        }, getInitialDelay(), 24 * 60 * 60 * 1000) // 24 hours
    }

    private fun getInitialDelay(): Long {
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 11)  // Set desired hour
        calendar.set(Calendar.MINUTE, 50)
        calendar.set(Calendar.SECOND, 0)

        val now = Calendar.getInstance()
        if (calendar.before(now)) {
            calendar.add(Calendar.DATE, 1)
        }
        return calendar.timeInMillis - now.timeInMillis
    }

    private fun createNotification(text: String): Notification {
        val channelId = "service_channel"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val chan = NotificationChannel(
                channelId,
                "Service Notifications",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(chan)
        }

        return NotificationCompat.Builder(this, channelId)
            .setContentTitle("Foreground Service")
            .setContentText(text)
            .setSmallIcon(R.mipmap.ic_launcher)
            .build()
    }

    private fun sendNotification() {
        val notificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        val channelId = "daily_channel"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Daily Notifications",
                NotificationManager.IMPORTANCE_HIGH
            )
            notificationManager.createNotificationChannel(channel)
        }

        val notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Daily Reminder")
            .setContentText("Hey! This is your daily notification.")
            .setSmallIcon(R.mipmap.ic_launcher)
            .build()

        notificationManager.notify(1001, notification)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
