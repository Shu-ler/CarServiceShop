// 
//	Аутсорсинг Групп 
//		+7 495 241 10 64
//		+7 3852 59 50 96
//		
//	Филимонов И.В.
//		+7 913 240 81 77
//
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает коллекцию ключей моделей по номенклатуре и характеристике
// 
// Параметры:
// 	Номенклатура - СправочникСсылка.Номенклатура  
// 	Характеристика - СправочникСсылка.ХарактеристикиНоменклатуры  
// Возвращаемое значение:
// 	ТаблицаЗначений - Описание
Функция НайтиПоНоменклатуре(Номенклатура, Характеристика = Неопределено, Модели = Неопределено, ДляДром = Ложь) Экспорт

	Если Характеристика = Неопределено Тогда
		Характеристика = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	КА2_КлючиМоделей.Ссылка,
				   |	КА2_КлючиМоделей.ТипТС,
				   |	КА2_КлючиМоделей.Марка,
				   |	КА2_КлючиМоделей.Марка.Владелец КАК МаркаНаименование,
				   |	КА2_КлючиМоделей.Модель,
				   |	КА2_КлючиМоделей.Модель.Владелец КАК МодельНаименование,
				   |	КА2_КлючиМоделей.Поколение,
				   |	ВЫБОР
				   |		КОГДА КА2_КлючиМоделей.Поколение <> ЗНАЧЕНИЕ(Справочник.КА2_Поколения.ПустаяСсылка)
				   |			ТОГДА ВЫБОР
				   |				КОГДА КА2_КлючиМоделей.Поколение.year_begin <> """"
				   |				И КА2_КлючиМоделей.Поколение.year_end <> """"
				   |					ТОГДА КА2_КлючиМоделей.Поколение.year_begin + ""-"" + КА2_КлючиМоделей.Поколение.year_end
				   |				КОГДА КА2_КлючиМоделей.Поколение.year_begin <> """"
				   |				И КА2_КлючиМоделей.Поколение.year_end = """"
				   |					ТОГДА КА2_КлючиМоделей.Поколение.year_begin
				   |				КОГДА КА2_КлючиМоделей.Поколение.year_begin = """"
				   |				И КА2_КлючиМоделей.Поколение.year_end <> """"
				   |					ТОГДА КА2_КлючиМоделей.Поколение.year_end
				   |				ИНАЧЕ """"
				   |			КОНЕЦ
				   |		ИНАЧЕ """"
				   |	КОНЕЦ КАК ГодыВыпуска,
				   |	КА2_КлючиМоделей.Кузов,
				   |	ЕСТЬNULL(КА2_КлючиМоделей.Кузов.Наименование, """") КАК КузовНаименование,
				   |	КА2_КлючиМоделей.Модификация,
				   |	КА2_КлючиМоделей.Комплектация,
				   |	ВЫБОР
				   |		КОГДА КА2_КлючиМоделей.Поколение <> ЗНАЧЕНИЕ(Справочник.КА2_Поколения.ПустаяСсылка)
				   |			ТОГДА КА2_КлючиМоделей.Поколение.year_begin
				   |		ИНАЧЕ """"
				   |	КОНЕЦ КАК ГодНП,
				   |	ВЫБОР
				   |		КОГДА КА2_КлючиМоделей.Поколение <> ЗНАЧЕНИЕ(Справочник.КА2_Поколения.ПустаяСсылка)
				   |			ТОГДА КА2_КлючиМоделей.Поколение.year_end
				   |		ИНАЧЕ """"
				   |	КОНЕЦ КАК ГодОП,
				   |	КА2_МоделиАвтомобилейДляНоменклатуры.Совместимо,
				   |	КА2_МоделиАвтомобилейДляНоменклатуры.Номер КАК Номер
				   |ИЗ
				   |	РегистрСведений.КА2_МоделиАвтомобилейДляНоменклатуры КАК КА2_МоделиАвтомобилейДляНоменклатуры
				   |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КА2_КлючиМоделей КАК КА2_КлючиМоделей
				   |		ПО КА2_МоделиАвтомобилейДляНоменклатуры.КлючМодели = КА2_КлючиМоделей.Ссылка
				   |ГДЕ
				   |	КА2_МоделиАвтомобилейДляНоменклатуры.Номенклатура = &Номенклатура
				   |	И КА2_МоделиАвтомобилейДляНоменклатуры.ХарактеристикаНоменклатуры = &ХарактеристикаНоменклатуры
				   |УПОРЯДОЧИТЬ ПО
				   |	Номер";
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("ХарактеристикаНоменклатуры", Характеристика);

	КоллекцияКлючей = Запрос.Выполнить().Выгрузить();

	Если Модели <> Неопределено Тогда
		Для Каждого Элемент Из КоллекцияКлючей Цикл
			Если Элемент.Совместимо = Истина Тогда
				Если ДляДром Тогда
					Модель = Новый Структура;
					Модель.Вставить("brandcars", Строка(Элемент.МаркаНаименование));
					Модель.Вставить("modelcars", Строка(Элемент.МодельНаименование));
					Модель.Вставить("generation", Строка(Элемент.Поколение));
					Модель.Вставить("bodycars", Строка(Элемент.КузовНаименование));
					Модель.Вставить("year", Строка(Элемент.ГодыВыпуска));
					Модели.Добавить(Модель);
				Иначе
					ТекстЗаписи = "";
					ТекстЗаписи = ТекстЗаписи
								  + Элемент.МаркаНаименование
								  + " "
								  + Элемент.МодельНаименование
								  + " "
								  + Элемент.ГодыВыпуска
								  + ?(ПустаяСтрока(Элемент.КузовНаименование), "", " " + Элемент.КузовНаименование)
								  + " ["
								  + Строка(Элемент.Поколение)
								  + "]";
					Модели.Добавить(ТекстЗаписи);
				КонецЕсли;
			КонецЕсли;

		КонецЦикла;
	КонецЕсли;

	Возврат КоллекцияКлючей;

КонецФункции

// Возвращает коллекцию ключей моделей по ключу модели
// 
// Параметры:
// 	КлючМодели - СправочникСсылка._КА2_КлючиМоделей  
// Возвращаемое значение:
// 	ТаблицаЗначений - Описание
Функция НайтиПоКлючуМодели(КлючМодели) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	КА2_КлючиМоделей.Ссылка,
				   |	КА2_КлючиМоделей.ТипТС,
				   |	КА2_КлючиМоделей.Марка,
				   |	КА2_КлючиМоделей.Марка.Владелец КАК МаркаНаименование,
				   |	КА2_КлючиМоделей.Модель,
				   |	КА2_КлючиМоделей.Модель.Владелец КАК МодельНаименование,
				   |	КА2_КлючиМоделей.Поколение,
				   |	ВЫБОР
				   |		КОГДА КА2_КлючиМоделей.Поколение <> ЗНАЧЕНИЕ(Справочник.КА2_Поколения.ПустаяСсылка)
				   |			ТОГДА ВЫБОР
				   |				КОГДА КА2_КлючиМоделей.Поколение.year_begin <> """"
				   |				И КА2_КлючиМоделей.Поколение.year_end <> """"
				   |					ТОГДА КА2_КлючиМоделей.Поколение.year_begin + ""-"" + КА2_КлючиМоделей.Поколение.year_end
				   |				КОГДА КА2_КлючиМоделей.Поколение.year_begin <> """"
				   |				И КА2_КлючиМоделей.Поколение.year_end = """"
				   |					ТОГДА КА2_КлючиМоделей.Поколение.year_begin
				   |				КОГДА КА2_КлючиМоделей.Поколение.year_begin = """"
				   |				И КА2_КлючиМоделей.Поколение.year_end <> """"
				   |					ТОГДА КА2_КлючиМоделей.Поколение.year_end
				   |				ИНАЧЕ """"
				   |			КОНЕЦ
				   |		ИНАЧЕ """"
				   |	КОНЕЦ КАК ГодыВыпуска,
				   |	КА2_КлючиМоделей.Кузов,
				   |	ЕСТЬNULL(КА2_КлючиМоделей.Кузов.Наименование, """") КАК КузовНаименование,
				   |	КА2_КлючиМоделей.Модификация,
				   |	КА2_КлючиМоделей.Комплектация,
				   |	ВЫБОР
				   |		КОГДА КА2_КлючиМоделей.Поколение <> ЗНАЧЕНИЕ(Справочник.КА2_Поколения.ПустаяСсылка)
				   |			ТОГДА КА2_КлючиМоделей.Поколение.year_begin
				   |		ИНАЧЕ """"
				   |	КОНЕЦ КАК ГодНП,
				   |	ВЫБОР
				   |		КОГДА КА2_КлючиМоделей.Поколение <> ЗНАЧЕНИЕ(Справочник.КА2_Поколения.ПустаяСсылка)
				   |			ТОГДА КА2_КлючиМоделей.Поколение.year_end
				   |		ИНАЧЕ """"
				   |	КОНЕЦ КАК ГодОП,
				   |	ИСТИНА как Совместимо
				   |ИЗ
				   |	Справочник.КА2_КлючиМоделей КАК КА2_КлючиМоделей
				   |ГДЕ
				   |	КА2_КлючиМоделей.Ссылка = &КлючМодели";
	Запрос.УстановитьПараметр("КлючМодели", КлючМодели);

	КоллекцияКлючей = Запрос.Выполнить().Выгрузить();

	Возврат КоллекцияКлючей;

КонецФункции

// Возвращает коллекцию ключей моделей по номенклатуре и характеристике
// 
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура -
//  Характеристика - СправочникСсылка.ХарактеристикиНоменклатуры -
//  Модели - Неопределено - Модели
// 
Процедура НайтиПоНоменклатуреДляДром(Номенклатура, Характеристика = Неопределено, Модели = Неопределено) Экспорт

	Если Характеристика = Неопределено Тогда
		Характеристика = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	Ключи.Марка.Наименование КАК МаркаНаименование,
				   |	Ключи.Модель.Наименование КАК МодельНаименование,
				   |	Ключи.Поколение.Наименование КАК ПоколениеНаименование,
				   |	Ключи.Модификация.Наименование КАК МодификацияНаименование,
				   |	ЕСТЬNULL(Ключи.Кузов.Наименование, """") КАК КузовНаименование,
				   |	Связи.Совместимо КАК Совместимо,
				   |	Связи.Номер КАК Номер,
				   |	ВЫБОР
				   |		КОГДА Ключи.Поколение <> ЗНАЧЕНИЕ(Справочник.КА2_Поколения.ПустаяСсылка)
				   |			ТОГДА ВЫБОР
				   |				КОГДА Ключи.Поколение.year_begin <> """"
				   |				И Ключи.Поколение.year_end <> """"
				   |					ТОГДА Ключи.Поколение.year_begin + ""-"" + Ключи.Поколение.year_end
				   |				КОГДА Ключи.Поколение.year_begin <> """"
				   |				И Ключи.Поколение.year_end = """"
				   |					ТОГДА Ключи.Поколение.year_begin
				   |				КОГДА Ключи.Поколение.year_begin = """"
				   |				И Ключи.Поколение.year_end <> """"
				   |					ТОГДА Ключи.Поколение.year_end
				   |				ИНАЧЕ """"
				   |			КОНЕЦ
				   |		ИНАЧЕ """"
				   |	КОНЕЦ КАК ГодыВыпуска,
				   |	Ключи.Поколение.bodycars КАК bodycars
				   |ИЗ
				   |	РегистрСведений.КА2_МоделиАвтомобилейДляНоменклатуры КАК Связи
				   |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КА2_КлючиМоделей КАК Ключи
				   |		ПО Связи.КлючМодели = Ключи.Ссылка
				   |ГДЕ
				   |	Связи.Номенклатура = &Номенклатура
				   |	И Связи.ХарактеристикаНоменклатуры = &ХарактеристикаНоменклатуры
				   |	И Связи.Совместимо = ИСТИНА
				   |УПОРЯДОЧИТЬ ПО
				   |	Номер";
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("ХарактеристикаНоменклатуры", Характеристика);

	КоллекцияКлючей = Запрос.Выполнить().Выбрать();

	Если Модели <> Неопределено Тогда

		Пока КоллекцияКлючей.Следующий() Цикл
			Модель = Новый Структура;
			Модель.Вставить("brandcars", КоллекцияКлючей.МаркаНаименование);
			Модель.Вставить("modelcars", КоллекцияКлючей.МодельНаименование);
			Модель.Вставить("generation", КоллекцияКлючей.ПоколениеНаименование);
			Модель.Вставить("bodycars", КоллекцияКлючей.bodycars);
//			Модель.Вставить("bodycars", КоллекцияКлючей.КузовНаименование);
			Модель.Вставить("year", КоллекцияКлючей.ГодыВыпуска);
			Модели.Добавить(Модель);
		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

// Конструктор структуры параметров 
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * Комплектация - СправочникСсылка.КА2_Комплектации -
// * Модификация - СправочникСсылка.КА2_Модификации -
// * Кузов - СправочникСсылка.КА2_Кузова -
// * Поколение - СправочникСсылка.КА2_Поколения -
// * Модель - СправочникСсылка.КА2_Модели -
// * Марка - СправочникСсылка.КА2_Марки -
// * ТипТС - СправочникСсылка.КА2_Типы -
Функция СтруктураПараметров() Экспорт

	СП = Новый Структура;
	СП.Вставить("ТипТС", Справочники.КА2_Типы.ПустаяСсылка());
	СП.Вставить("Марка", Справочники.КА2_Марки.ПустаяСсылка());
	СП.Вставить("Модель", Справочники.КА2_Модели.ПустаяСсылка());
	СП.Вставить("Поколение", Справочники.КА2_Поколения.ПустаяСсылка());
	СП.Вставить("Кузов", Справочники.КА2_Кузова.ПустаяСсылка());
	СП.Вставить("Модификация", Справочники.КА2_Модификации.ПустаяСсылка());
	СП.Вставить("Комплектация", Справочники.КА2_Комплектации.ПустаяСсылка());

	Возврат СП;

КонецФункции

// Возвращает ссылку уникального ключа модели по параметрам
// 
// Параметры:
// 	Параметры - Структура - Параметры поиска
// Возвращаемое значение:
// 	СправочникСсылка.КА2_КлючиМоделей, Неопределено - Описание
Функция НайтиУникальный(Параметры) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	КА2_КлючиМоделей.Ссылка
				   |ИЗ
				   |	Справочник.КА2_КлючиМоделей КАК КА2_КлючиМоделей
				   |ГДЕ
				   |	КА2_КлючиМоделей.ТипТС = &ТипТС
				   |	И КА2_КлючиМоделей.Марка = &Марка
				   |	И КА2_КлючиМоделей.Модель = &Модель
				   |	И КА2_КлючиМоделей.Поколение = &Поколение
				   |	И КА2_КлючиМоделей.Кузов = &Кузов
				   |	И КА2_КлючиМоделей.Модификация = &Модификация
				   |	И КА2_КлючиМоделей.Комплектация = &Комплектация";
	Запрос.УстановитьПараметр("ТипТС", Параметры.ТипТС);
	Запрос.УстановитьПараметр("Марка", Параметры.Марка);
	Запрос.УстановитьПараметр("Модель", Параметры.Модель);
	Запрос.УстановитьПараметр("Поколение", Параметры.Поколение);
	Запрос.УстановитьПараметр("Кузов", Параметры.Кузов);
	Запрос.УстановитьПараметр("Модификация", Параметры.Модификация);
	Запрос.УстановитьПараметр("Комплектация", Параметры.Комплектация);

	НайденыКлючи = Запрос.Выполнить().Выгрузить();
	Возврат ?(НайденыКлючи.Количество() > 0, НайденыКлючи[0].Ссылка, Неопределено);

КонецФункции

Функция ПолучитьУникальный(ДанныеКлюча) Экспорт

	ИскомыйКлюч = Справочники.КА2_КлючиМоделей.НайтиУникальный(ДанныеКлюча);

	Если ИскомыйКлюч = Неопределено Или СтрНайти(Строка(ИскомыйКлюч), "(не использовать)") = 1 Тогда
		ДанныеКлючаСтруктура = КА2_КаталогАвтомобилейВызовСервера.ПроизвольныеДанныеВСтруктуру(ДанныеКлюча,
																							   "КА2_КлючиМоделей");
		ИскомыйКлючОбъект = Справочники.КА2_КлючиМоделей.СоздатьЭлемент();
	Иначе
		ИскомыйКлючОбъект = ИскомыйКлюч.ПолучитьОбъект();
	КонецЕсли;

	ИскомыйКлючОбъект.Заполнить(ДанныеКлючаСтруктура);

	Попытка
		ИскомыйКлючОбъект.Записать();
		Результат = ИскомыйКлючОбъект.Ссылка;
	Исключение
		Результат = Неопределено;
	КонецПопытки;

	Возврат Результат;

КонецФункции

// Перезаписывает все ключи моделей
// 
// Параметры:
// 	БезПометкиНаУдаление - Булево - Истина - перезаписать только без пометок на удаление
Процедура ОбновитьВсе(БезПометкиНаУдаление = Ложь) Экспорт

	ЗапросТекст = "ВЫБРАТЬ
				  |	КА2_КлючиМоделей.Ссылка
				  |ИЗ
				  |	Справочник.КА2_КлючиМоделей КАК КА2_КлючиМоделей";

	ЗапросТекстДополнение = "|ГДЕ
							|	НЕ КА2_КлючиМоделей.ПометкаУдаления";
	Запрос = Новый Запрос;
	Запрос.Текст = ЗапросТекст + ?(БезПометкиНаУдаление, ЗапросТекстДополнение, "");

	НаОбновление = Запрос.Выполнить().Выбрать();
	НаОбновлениеКоличество = НаОбновление.Количество();
	Успешно = 0;
	Ошибок = 0;

	Пока НаОбновление.Следующий() Цикл

		Попытка
			КлючОбъект = НаОбновление.Ссылка.ПолучитьОбъект();
			КлючОбъект.Записать();
			Успешно = Успешно + 1;
		Исключение
			Ошибок = Ошибок + 1;
		КонецПопытки;

	КонецЦикла;

	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = СтрШаблон("Обновление завершено. Всего на обновление %1, обновлено успешно %2, ошибок %3",
								НаОбновлениеКоличество,
								Успешно,
								Ошибок);
	Сообщение.Сообщить();

КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)

	Поля.Добавить("Марка");
	Поля.Добавить("ПоколениеКузов");

	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)

	Марка = Строка(Данные.Марка);
	Представление = СтрШаблон("%1 %2", Марка, Данные.ПоколениеКузов);

	СтандартнаяОбработка = Ложь;

КонецПроцедуры

#КонецОбласти

#КонецЕсли