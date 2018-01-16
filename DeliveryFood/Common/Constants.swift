//
//  Constants.swift
//  DeliveryFood
//
//  Created by B0Dim on 27.09.17.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK: Properties for company
var PHONE = ""
var COST_DELIVERY = 300
var COST_ORDER_DEFAULT = 0
var CURRENCY = "₽ "
var COST_FREE_DELIVERY = 1000
var COMPANY_ID = 15
var CITY = "Хабаровск"
// ВЫПИЛИТЬ
var WORK_HOUR_FROM = 11
var WORK_HOUR_TO = 20
var WORK_MINUTES_FROM = 0
var WORK_MINUTES_TO = 0

var WORK_DAYS = [JSON]()
var DELIVERY_DISCONT = 10
var COMPANY_INFO = ""
var COMPANY_EMAIL = ["bodakovda@arink-group.ru"]
var GEOTAG = ["48.491258,135.083673"]
var GEOTAG_CAFE = ["48.469463,135.071622"]
var CENTER_MAP = "48.477251,135.083662"
var TIME_ZONE = " +10"
var TIME_ZONE_TITLE = " (хаб. время)"

//MARK: Colors
var FIRST_COLOR = 0x000000
var FIRST_COLOR_TEXT = 0xFFFFFF
var SECOND_COLOR = 0xebebf1
var SECOND_COLOR_TEXT = 0x000000
var CONTROL_COLOR = 0xd60000
var CONTROL_COLOR_TEXT = 0xFFFFFF
var CONTROL_COLOR_NOT_SELECTED = 0xFFFFFF
var CONTROL_COLOR_TEXT_NOT_SELECTED = 0x000000

//var FIRST_COLOR = 0xFA8109
//var SECOND_COLOR = 0x9BC122 //AAC92D


//MARK: Server properties
var SERVER_NAME = "http://23.101.67.216:8080"

//MARK: Settings
var MAP_KEY = "AIzaSyDIbcT6MCPC0VslV-XnT1TwTFbm5dAF27w"
var FEEDBACK_TXT = "Расскажите нам что вы думаете о нашем приложении?!\nЧто вам нравится в нем? Что следует изменить?\nВаше мнение поможет улучшить сервис!\n\n"

//MARK: STATUSES
var ST_ACTIVE: [String] = ["Новый","Подтвержден"]
var ST_CANCEL = "Отменен"

//MARK: Errors
var ERR_CHECK_DATA = "Мы сожалеем, но что-то пошло не так. Проверьте пожалуйста введенные данные."
var ERR_CHECK_DATA_PHONE = "Мы сожалеем, но что-то пошло не так. Проверьте пожалуйста введенные данные (номер телефона)."
var ERR_CHECK_INTERNET = "Мы сожалеем, но что-то пошло не так. Проверьте пожалуйста соединение с интернетом."
var ERR_NEED_ADD_CONTACT = "Необходимо заполнить контактые данные в разделе профиль"
var ERR_CHECK_ADDRESS = "Проверьте введенные данные и выберите адрес доставки."
var ERR_CHECK_DATA_TIME = "Мы сожалеем, но что-то пошло не так. Проверьте введенные данные и время доставки."

var ERROR_DELIVERY_NOT_WORKING = "Увы, доставка не работает... Но!\nВы можете сделать заказ немного позже!\nВаш заказ сохранится в телефоне и дождется вашего возвращения.\n\n Время работы доставки " + TIME_ZONE_TITLE + ":"

var ERR_NEED_ADD_PRODUCT = "Для добавления ингредиентов необходимо добавить продукт в корзину"
var ERR_CANT_DELETE_ORDER = "Ваш заказ подтвержден. Его отменить нельзя! Позвоните оператору."
var ERR_CHECK_CONTACTS = "Не верно заполнены контактные данные. Пожалуйста проверьте их."


//MARK: Phone versions
var DB_VERSION = 2
