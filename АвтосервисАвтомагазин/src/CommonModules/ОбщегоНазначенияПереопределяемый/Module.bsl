//
//	Филимонов И.В.
//		+7 913 240 81 77
//		

#Область ПрограммныйИнтерфейс

&После("ПриДобавленииОбработчиковУстановкиПараметровСеанса")
Процедура АС2_ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт

	Обработчики.Вставить(Метаданные.ПараметрыСеанса.КА2_ИмяГруппыФильтра.Имя,
						 "КА2_СлужебныеВызовСервера.УстановкаПараметровСеансаИмяГруппыФильтра");
	Обработчики.Вставить(Метаданные.ПараметрыСеанса.КА2_КлючиМоделейПустыеПоля.Имя,
						 "КА2_СлужебныеВызовСервера.УстановкаПараметровСеансаКлючиМоделейПустыеПоля");
	Обработчики.Вставить(Метаданные.ПараметрыСеанса.КА2_ПанельРазмещенияКнопки.Имя,
						 "КА2_СлужебныеВызовСервера.УстановкаПараметровСеансаПанельРазмещенияКнопки");
	Обработчики.Вставить(Метаданные.ПараметрыСеанса.КА2_ПВХ.Имя,
						 "КА2_СлужебныеВызовСервера.УстановкаПараметровСеансаПВХ");
	Обработчики.Вставить(Метаданные.ПараметрыСеанса.КА2_ПоляКлючейМоделей.Имя,
						 "КА2_СлужебныеВызовСервера.УстановкаПараметровСеансаПоляКлючейМоделей");
	Обработчики.Вставить(Метаданные.ПараметрыСеанса.КА2_СигнатурыОтбора.Имя,
						 "КА2_СлужебныеВызовСервера.УстановкаПараметровСеансаСигнатурыОтбора");
КонецПроцедуры


#КонецОбласти