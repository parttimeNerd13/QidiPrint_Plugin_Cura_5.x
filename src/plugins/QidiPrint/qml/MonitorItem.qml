import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import UM as UM
import Cura as Cura

import "."

Component
{
    id: monitorItem

    Item
    {
        UM.I18nCatalog { id: catalog; name: "cura"}
        property var connectedDevice: Cura.MachineManager.printerOutputDevices.length >= 1 ? Cura.MachineManager.printerOutputDevices[0] : null
        property var activePrinter: connectedDevice != null ? connectedDevice.activePrinter : null        

        Rectangle
        {
            id: mainPanel

            color: UM.Theme.getColor("main_background")

            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: sidebarPanel.left
                rightMargin: UM.Theme.getSize("default_margin").width
            }

            UM.Label {
                id: cameraLabel

                anchors {
                    horizontalCenter: parent.horizontalCenter;
                    verticalCenter: parent.verticalCenter;
                }
                color: UM.Theme.getColor(OutputDevice.activePrinter != null && OutputDevice.activePrinter.cameraUrl != null && OutputDevice.activePrinter.cameraUrl != "" ? "text" : "text_inactive")
                font: UM.Theme.getFont("large_bold")
                text: OutputDevice.activePrinter != null && OutputDevice.activePrinter.cameraUrl != null && OutputDevice.activePrinter.cameraUrl != "" ? "Camera" : "Camera not configured"
            }
            UM.Label {                
                id: cameraLabelUrl

                visible: OutputDevice.activePrinter != null && OutputDevice.activePrinter.cameraUrl != null && OutputDevice.activePrinter.cameraUrl != ""
                anchors {
                    horizontalCenter: cameraLabel.horizontalCenter;
                    top: cameraLabel.bottom;
                }
                color: UM.Theme.getColor("text_inactive")
                font: UM.Theme.getFont("small")
                text: "Url: " + (OutputDevice.activePrinter != null && OutputDevice.activePrinter.cameraUrl != null ? OutputDevice.activePrinter.cameraUrl : "Null")
            }

            Cura.NetworkMJPGImage { 
                property real scale: Math.min(Math.min((parent.width - 6 * UM.Theme.getSize("default_margin").width) / imageWidth, (parent.height - 6 * UM.Theme.getSize("default_margin").height) / imageHeight), 2);

                id: cameraImage;
                anchors {
                    horizontalCenter: parent.horizontalCenter;
                    verticalCenter: parent.verticalCenter;
                }
                width: Math.floor(imageWidth * scale)
                height: Math.floor(imageHeight * scale)
                source: OutputDevice.activePrinter != null && OutputDevice.activePrinter.cameraUrl != null ? OutputDevice.activePrinter.cameraUrl : ""
                onVisibleChanged: {
                    if (visible) {
                        if (OutputDevice.activePrinter != null && OutputDevice.activePrinter.cameraUrl != null) {
                            cameraImage.start();
                        }
                    } else {
                        if (OutputDevice.activePrinter != null && OutputDevice.activePrinter.cameraUrl != null) {
                            cameraImage.stop();
                        }
                    }
                }
                Component.onCompleted: {
                    if (OutputDevice.activePrinter != null && OutputDevice.activePrinter.cameraUrl != null) {
                        cameraImage.start();
                    }
                }
            }
        }

        Rectangle
        {
            id: sidebarPanel

            color: UM.Theme.getColor("main_background")

            anchors.right: parent.right
            width: parent.width * 0.3
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            UM.Label
            {
                font: UM.Theme.getFont("large_bold")
                color: UM.Theme.getColor("text")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: UM.Theme.getSize("default_margin").width
                text: catalog.i18nc("@info:status", "The printer is not connected.")
                visible:
                {
                     if(activePrinter != null)
                    {
                        return activePrinter.state == "offline"
                    }
                    return true
                }                
            }

            Rectangle{
                anchors.top: parent.top
                anchors.bottom: footerSeparator.top
                anchors.left: parent.left
                anchors.right: parent.right
                
                PrintMonitor
                {
                    visible:
                    {
                        if(activePrinter != null)
                        {
                            return activePrinter.state != "offline"
                        }
                        return false                
                        
                    }                
                    anchors.fill: parent
                }
            }

            Rectangle
            {
                id: footerSeparator
                width: parent.width
                height: UM.Theme.getSize("wide_lining").height
                color: UM.Theme.getColor("wide_lining")
                anchors.bottom: monitorButton.top
                anchors.bottomMargin: UM.Theme.getSize("thick_margin").height
            }

            // MonitorButton is actually the bottom footer panel.
            Cura.MonitorButton
            {
                id: monitorButton
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }
    }
}