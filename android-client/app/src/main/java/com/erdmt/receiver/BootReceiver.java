package com.erdmt.receiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class BootReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d("BootReceiver", "Device booted");
        context.startService(new Intent(context, com.erdmt.service.ERDMTService.class));
    }
}
