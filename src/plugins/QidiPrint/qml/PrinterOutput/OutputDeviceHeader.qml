import QtQuick

import QtQuick.Controls
import QtQuick.Layouts

import UM as UM
import Cura as Cura


Item
{
    implicitWidth: parent.width
    implicitHeight: Math.floor(childrenRect.height + UM.Theme.getSize("default_margin").height * 2)
    property var outputDevice: null

    Connections
    {
        target: Cura.MachineManager
        function onGlobalContainerChanged()
        {
            outputDevice = Cura.MachineManager.printerOutputDevices.length >= 1 ? Cura.MachineManager.printerOutputDevices[0] : null;
        }
    }

    Rectangle
    {
        height: childrenRect.height
        color: UM.Theme.getColor("setting_category")

        UM.Label
        {
            id: outputDeviceNameLabel
            font: UM.Theme.getFont("large_bold")
            color: UM.Theme.getColor("text")
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: UM.Theme.getSize("default_margin").width
            text: outputDevice != null ? outputDevice.activePrinter.name : ""
        }

        UM.Label
        {
            id: outputDeviceAddressLabel
            text: (outputDevice != null && outputDevice.address != null) ? "IP: " + outputDevice.address : ""
            font: UM.Theme.getFont("default_bold")
            color: UM.Theme.getColor("text_inactive")
            anchors.top: outputDeviceNameLabel.bottom
            anchors.left: parent.left
            anchors.margins: UM.Theme.getSize("default_margin").width
        }

        UM.Label
        {
            id: outputDeviceWebcamLabel
            text: (outputDevice != null && outputDevice.address != null && outputDevice.webcam != null && outputDevice.webcam != "") ? "          Webcam:" : ""
            font: UM.Theme.getFont("default_bold")
            color: UM.Theme.getColor("text_inactive")
            anchors.top: outputDeviceNameLabel.bottom
            anchors.left: outputDeviceAddressLabel.right
            anchors.margins: UM.Theme.getSize("default_margin").width
        }

        UM.Label
        {
            id: outputDeviceWebcamLink
            text: (outputDevice != null && outputDevice.address != null && outputDevice.webcam != null && outputDevice.webcam != "") ? '<html><a href="' + outputDevice.webcam + '">' + outputDevice.webcam + '</a></html>' : ""
            onLinkActivated: Qt.openUrlExternally(link)
            font: UM.Theme.getFont("default_bold")
            color: UM.Theme.getColor("text_inactive")
            anchors.top: outputDeviceNameLabel.bottom
            anchors.left: outputDeviceWebcamLabel.right
            anchors.margins: UM.Theme.getSize("default_margin").width
        }
    }
}