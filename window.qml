/* Freepv is a free picture viewer.
 * Distributed under GPL, Version 3.0.
 * The file defines the appwindow of freepv, and setts up all UIs' logic, except the content's.
 *  Author: stardust
 *  Data: 2019-06-01
**/
import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

ApplicationWindow{
    id:appWindow
    visible: true
    width: 600
    height: 400

    menuBar: MenuBar{
        id:appMenuBar

        Menu{
            title: qsTr("&File")
            //RECOMMENDED Way: to encapsulate actions using MenuItem
            MenuItem{action: actions.openAction}
            MenuItem{action: actions.folderAction}
            MenuItem{action: actions.exitAction}
        }

        Menu{
            title: qsTr("&View")
            //using Action object as menu item directly
            Action{
                text:qsTr("&Full Screen")
                icon.name:"view-fullscreen"
                onTriggered: {
                    content.fullScreen();
                }
            }
            //sub menu
            Menu{
                title: qsTr("ViewMode")
                MenuItem{action: actions.imageModePreserveAspectCropAction}
                MenuItem{action: actions.imageModePreserveAspectFitAction}
                MenuItem{action: actions.imageModeStretchAction}
            }
        }

        Menu {
            title: qsTr("&Help")
            //using Action object id as menu item
            contentData:[ actions.contentsAction,
                actions.aboutAction ]
        }
    }

    header: ToolBar {
        id:appToolBar
        RowLayout{
            ToolButton{ action: actions.openAction }
            ToolButton{ action: actions.folderAction }
        }
    }

    //setting the logic of all actions
    Actions{
        id:actions
        openAction.onTriggered: dialogs.openFileDialog()
        folderAction.onTriggered: dialogs.openFolderDialog()
        imageModePreserveAspectCropAction.onTriggered: content.setImageFillMode(Image.PreserveAspectCrop)
        imageModePreserveAspectFitAction.onTriggered: content.setImageFillMode(Image.PreserveAspectFit)
        imageModeStretchAction.onTriggered: content.setImageFillMode(Image.Stretch)
        aboutAction.onTriggered: dialogs.openAboutDialog()
    }

    //setting the logic of all dialogs
    Dialogs{
        id:dialogs
        fileOpenDialog.selectMultiple: true
        fileOpenDialog.onAccepted:
            content.setFilesModel(fileOpenDialog.fileUrls)

        folderOpenDialog.selectFolder:true
        folderOpenDialog.onAccepted:
            content.setFolderModel(folderOpenDialog.folder);
    }

    //setting the logic of content
    Content{
        id:content
        anchors.fill: parent
        onFullScreen: {
            menuBar.visible = false;
            header.visible = false;
            appWindow.showFullScreen();
            isFullScreen = true;
            singleView();
        }
        onWindow: {
            menuBar.visible = true
            header.visible = true
            appWindow.showNormal()
            isFullScreen=false;
        }
    }

}
