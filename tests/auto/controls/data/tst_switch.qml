/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the test suite of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtTest 1.0
import QtQuick.Controls 2.0

TestCase {
    id: testCase
    width: 200
    height: 200
    visible: true
    when: windowShown
    name: "Switch"

    Component {
        id: swtch
        Switch { }
    }

    Component {
        id: signalSequenceSpy
        SignalSequenceSpy {
            signals: ["pressed", "released", "canceled", "clicked", "pressedChanged", "checkedChanged"]
        }
    }

    function test_text() {
        var control = swtch.createObject(testCase)
        verify(control)

        compare(control.text, "")
        control.text = "Switch"
        compare(control.text, "Switch")
        control.text = ""
        compare(control.text, "")

        control.destroy()
    }

    function test_checked() {
        var control = swtch.createObject(testCase)
        verify(control)

        compare(control.checked, false)

        var spy = signalSequenceSpy.createObject(control, {target: control})
        spy.expectedSequence = [["checkedChanged", { "checked": true }]]
        control.checked = true
        compare(control.checked, true)
        verify(spy.success)

        spy.expectedSequence = [["checkedChanged", { "checked": false }]]
        control.checked = false
        compare(control.checked, false)
        verify(spy.success)

        control.destroy()
    }

    function test_mouse() {
        var control = swtch.createObject(testCase)
        verify(control)

        // check
        var spy = signalSequenceSpy.createObject(control, {target: control})
        spy.expectedSequence = [["pressedChanged", { "pressed": true, "checked": false }],
                                "pressed"]
        mousePress(control, control.width / 2, control.height / 2, Qt.LeftButton)
        compare(control.pressed, true)
        verify(spy.success)
        spy.expectedSequence = [["pressedChanged", { "pressed": false, "checked": false }],
                                ["checkedChanged", { "pressed": false, "checked": true }],
                                "released",
                                "clicked"]
        mouseRelease(control, control.width / 2, control.height / 2, Qt.LeftButton)
        compare(control.checked, true)
        compare(control.pressed, false)
        verify(spy.success)

        // uncheck
        spy.expectedSequence = [["pressedChanged", { "pressed": true, "checked": true }],
                                "pressed"]
        mousePress(control, control.width / 2, control.height / 2, Qt.LeftButton)
        compare(control.pressed, true)
        verify(spy.success)
        spy.expectedSequence = [["pressedChanged", { "pressed": false, "checked": true }],
                                ["checkedChanged", { "pressed": false, "checked": false }],
                                "released",
                                "clicked"]
        mouseRelease(control, control.width / 2, control.height / 2, Qt.LeftButton)
        compare(control.checked, false)
        compare(control.pressed, false)
        verify(spy.success)

        // release on the right
        spy.expectedSequence = [["pressedChanged", { "pressed": true, "checked": false }],
                                "pressed"]
        mousePress(control, control.width / 2, control.height / 2, Qt.LeftButton)
        compare(control.pressed, true)
        verify(spy.success)
        mouseMove(control, control.width * 2, control.height / 2, 0, Qt.LeftButton)
        compare(control.pressed, true)
        spy.expectedSequence = [["pressedChanged", { "pressed": false, "checked": false }],
                                ["checkedChanged", { "pressed": false, "checked": true }],
                                "released",
                                "clicked"]
        mouseRelease(control, control.width * 2, control.height / 2, Qt.LeftButton)
        compare(control.checked, true)
        compare(control.pressed, false)
        verify(spy.success)

        // release on the left
        spy.expectedSequence = [["pressedChanged", { "pressed": true, "checked": true }],
                                "pressed"]
        mousePress(control, control.width / 2, control.height / 2, Qt.LeftButton)
        compare(control.pressed, true)
        verify(spy.success)
        mouseMove(control, -control.width, control.height / 2, 0, Qt.LeftButton)
        compare(control.pressed, true)
        spy.expectedSequence = [["pressedChanged", { "pressed": false, "checked": true }],
                                ["checkedChanged", { "pressed": false, "checked": false }],
                                "released",
                                "clicked"]
        mouseRelease(control, -control.width, control.height / 2, Qt.LeftButton)
        compare(control.checked, false)
        compare(control.pressed, false)
        verify(spy.success)

        // right button
        spy.expectedSequence = []
        mousePress(control, control.width / 2, control.height / 2, Qt.RightButton)
        compare(control.pressed, false)
        verify(spy.success)
        mouseRelease(control, control.width / 2, control.height / 2, Qt.RightButton)
        compare(control.checked, false)
        compare(control.pressed, false)
        verify(spy.success)

        control.destroy()
    }

    function test_keys() {
        var control = swtch.createObject(testCase)
        verify(control)

        control.forceActiveFocus()
        verify(control.activeFocus)

        // check
        var spy = signalSequenceSpy.createObject(control, {target: control})
        spy.expectedSequence = [["pressedChanged", { "pressed": true, "checked": false }],
                                "pressed",
                                ["pressedChanged", { "pressed": false, "checked": false }],
                                ["checkedChanged", { "pressed": false, "checked": true }],
                                "released",
                                "clicked"]
        keyClick(Qt.Key_Space)
        compare(control.checked, true)
        verify(spy.success)

        // uncheck
        spy.expectedSequence = [["pressedChanged", { "pressed": true, "checked": true }],
                                "pressed",
                                ["pressedChanged", { "pressed": false, "checked": true }],
                                ["checkedChanged", { "pressed": false, "checked": false }],
                                "released",
                                "clicked"]
        keyClick(Qt.Key_Space)
        compare(control.checked, false)
        verify(spy.success)

        // no change
        spy.expectedSequence = []
        var keys = [Qt.Key_Enter, Qt.Key_Return, Qt.Key_Escape, Qt.Key_Tab]
        for (var i = 0; i < keys.length; ++i) {
            keyClick(keys[i])
            compare(control.checked, false)
            verify(spy.success)
        }

        control.destroy()
    }

    Component {
        id: twoSwitches
        Item {
            property Switch sw1: Switch { id: sw1 }
            property Switch sw2: Switch { id: sw2; checked: sw1.checked; enabled: false }
        }
    }

    function test_binding() {
        var container = twoSwitches.createObject(testCase)
        verify(container)

        compare(container.sw1.checked, false)
        compare(container.sw2.checked, false)

        container.sw1.checked = true
        compare(container.sw1.checked, true)
        compare(container.sw2.checked, true)

        container.sw1.checked = false
        compare(container.sw1.checked, false)
        compare(container.sw2.checked, false)

        container.destroy()
    }

    function test_baseline() {
        var control = swtch.createObject(testCase)
        verify(control)
        compare(control.baselineOffset, control.contentItem.y + control.contentItem.baselineOffset)
        control.destroy()
    }

    function test_focus() {
        var control = swtch.createObject(testCase)
        verify(control)

        verify(!control.activeFocus)
        mouseClick(control.indicator)
        verify(control.activeFocus)

        control.destroy()
    }
}
