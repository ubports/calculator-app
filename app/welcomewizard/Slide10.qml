/*
 * Copyright (C) 2015 Canonical Ltd
 *
 * This file is part of Ubuntu Calculator App
 *
 * Ubuntu Calculator App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Calculator App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3

// Slide 10
Component {
    id: slide10

    SlideBase {
        slideTitle: i18n.tr("Copy formula")
        slideDescription: i18n.tr("You could copy formula by long pressing on formula (on Phone and Tablet), or by right mouse click (on Desktop), and selecting 'Copy' option from menu")
        slideImage: "../graphics/copy-formula.png"
    }
}
