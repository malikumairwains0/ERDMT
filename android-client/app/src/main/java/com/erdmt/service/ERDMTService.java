package com.erdmt.service;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;

public class ERDMTService extends Service {
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d("ERDMTService", "Service started");
        return START_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
