package com.erdmt.service;

import android.app.Service;
import android.content.Intent;
import android.database.Cursor;
import android.os.IBinder;
import android.provider.CallLog;
import android.util.Log;

public class CallLogService extends Service {
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        new Thread(() -> {
            try {
                Cursor cursor = getContentResolver().query(CallLog.Calls.CONTENT_URI, null, null, null, CallLog.Calls.DATE + " DESC");
                if (cursor != null && cursor.moveToFirst()) {
                    String number = cursor.getString(cursor.getColumnIndexOrThrow(CallLog.Calls.NUMBER));
                    String type = cursor.getString(cursor.getColumnIndexOrThrow(CallLog.Calls.TYPE));
                    String date = cursor.getString(cursor.getColumnIndexOrThrow(CallLog.Calls.DATE));
                    String duration = cursor.getString(cursor.getColumnIndexOrThrow(CallLog.Calls.DURATION));
                    Log.d("CallLogService", "Number: " + number + ", Type: " + type + ", Date: " + date + ", Duration: " + duration);
                    cursor.close();
                }
            } catch (Exception e) {
                Log.e("CallLogService", "Failed to read call logs", e);
            }
        }).start();
        return START_NOT_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
