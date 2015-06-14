/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qquickcontainer_p.h"
#include "qquickcontainer_p_p.h"

QT_BEGIN_NAMESPACE

/*!
    \qmltype Container
    \inherits Control
    \instantiates QQuickContainer
    \inqmlmodule QtQuick.Controls
    \qmlabstract
    \internal
*/

QQuickContainerPrivate::QQuickContainerPrivate() : contentItem(Q_NULLPTR)
{
}

void QQuickContainerPrivate::resizeContent()
{
    Q_Q(QQuickContainer);
    if (contentItem) {
        contentItem->setPosition(QPointF(q->leftPadding(), q->topPadding()));
        contentItem->setSize(QSizeF(q->contentWidth(), q->contentHeight()));
    }
}

QQuickContainer::QQuickContainer(QQuickItem *parent) :
    QQuickControl(*(new QQuickContainerPrivate), parent)
{
}

QQuickContainer::QQuickContainer(QQuickContainerPrivate &dd, QQuickItem *parent) :
    QQuickControl(dd, parent)
{
}

/*!
    \qmlproperty Item QtQuickControls2::Container::contentItem

    TODO
*/
QQuickItem *QQuickContainer::contentItem() const
{
    Q_D(const QQuickContainer);
    return d->contentItem;
}

void QQuickContainer::setContentItem(QQuickItem *item)
{
    Q_D(QQuickContainer);
    if (d->contentItem != item) {
        contentItemChange(item, d->contentItem);
        delete d->contentItem;
        d->contentItem = item;
        if (item) {
            if (!item->parentItem())
                item->setParentItem(this);
            if (isComponentComplete())
                d->resizeContent();
        }
        emit contentItemChanged();
    }
}

void QQuickContainer::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    Q_D(QQuickContainer);
    QQuickControl::geometryChanged(newGeometry, oldGeometry);
    d->resizeContent();
}

void QQuickContainer::paddingChange(const QMarginsF &newPadding, const QMarginsF &oldPadding)
{
    Q_D(QQuickContainer);
    QQuickControl::paddingChange(newPadding, oldPadding);
    d->resizeContent();
}

void QQuickContainer::contentItemChange(QQuickItem *newItem, QQuickItem *oldItem)
{
    Q_UNUSED(newItem);
    Q_UNUSED(oldItem);
}

QT_END_NAMESPACE
