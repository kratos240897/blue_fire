package com.mythstudios.blue_fire

import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.*
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

@RequiresApi(Build.VERSION_CODES.M)
@SuppressLint("MissingPermission")
class MainActivity : FlutterActivity() {
    private lateinit var filter: IntentFilter
    private lateinit var receiver: BroadcastReceiver
    private val newlyScannedDevices = arrayListOf<HashMap<String, String>>();
    private val pairedDevices = arrayListOf<Map<String, String>>();
    private lateinit var bluetoothManager: BluetoothManager
    private lateinit var bluetoothAdapter : BluetoothAdapter

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        bluetoothManager = context.getSystemService(BluetoothManager::class.java)
        bluetoothAdapter = bluetoothManager.adapter
        receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                when (intent.action) {
                    BluetoothDevice.ACTION_FOUND -> {
                        val bluetoothDevice = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                            intent.getParcelableExtra(
                                BluetoothDevice.EXTRA_DEVICE,
                                BluetoothDevice::class.java
                            )
                        }
                        else {
                            intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                        }
                        val device = HashMap<String, String>()
                        device["name"] =
                            if (bluetoothDevice?.name != null) bluetoothDevice.name else "unknown"
                        device["address"] =
                            if (bluetoothDevice?.address != null) bluetoothDevice.address else "unknown"
                        newlyScannedDevices.add(device)
                    }
                }
            }
        }
        filter = IntentFilter().apply {
            addAction(BluetoothDevice.ACTION_FOUND)
            addAction(BluetoothAdapter.ACTION_DISCOVERY_STARTED)
            addAction(BluetoothAdapter.ACTION_DISCOVERY_FINISHED)
        }
        context.registerReceiver(receiver, filter)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "startScanning" -> {
                    startDiscovery()
                    result.success(1)
                }
                "stopScanning" -> {
                    stopDiscovery()
                    result.success(1)
                }
                "getPairedDevices" -> {
                    result.success(getPairedDevices())
                }
                "getScannedDevices" -> {
                    result.success(getScannedDevices())
                }
            }
        }
    }

    private fun startDiscovery() {
        bluetoothAdapter.startDiscovery()
    }

    private fun getPairedDevices(): ArrayList<Map<String, String>> {
        pairedDevices.clear()
        bluetoothAdapter.bondedDevices.map {
            val device = HashMap<String, String>()
            device["name"] = it.name
            device["address"] = it.address
            pairedDevices.add(device)
        }
        return pairedDevices
    }

    private fun getScannedDevices(): ArrayList<HashMap<String, String>> {
        return newlyScannedDevices
    }

    private fun stopDiscovery() {
        newlyScannedDevices.clear()
        bluetoothAdapter.cancelDiscovery()
    }

    override fun onDestroy() {
        super.onDestroy()
        context.unregisterReceiver(receiver)
    }

    companion object {
        const val CHANNEL = "com.mythstudios.blue_fire/bluetooth";
    }
}
