// 
//	Аутсорсинг Групп 
//		+7 495 241 10 64
//		+7 3852 59 50 96
//		
//	Филимонов И.В.
//		+7 913 240 81 77
//
#Область ПрограммныйИнтерфейс

// С помощью ПриОпределенииВидовПодключаемыхКоманд можно определить собственные виды подключаемых команд,
// помимо уже предусмотренных в стандартной поставке (печатные формы, отчеты и команды заполнения).
//
// Параметры:
//   ВидыПодключаемыхКоманд - ТаблицаЗначений - поддерживаемые виды команд:
//       * Имя         - Строка            - имя вида команд. Должно удовлетворять требованиям именования переменных и
//                                           быть уникальным (не совпадать с именами других видов).
//                                           Может соответствовать имени подсистемы, отвечающей за вывод этих команд.
//                                           Следующие имена зарезервированы: "Печать", "Отчеты", "ЗаполнениеОбъектов".
//       * ИмяПодменю  - Строка            - имя подменю для размещения команд этого вида на формах объектов.
//       * Заголовок   - Строка            - наименование подменю, выводимое пользователю.
//       * Картинка    - Картинка          - картинка подменю.
//       * Отображение - ОтображениеКнопки - режим отображения подменю.
//       * Порядок     - Число             - порядок подменю в командной панели формы объекта по отношению 
//                                           к другим подменю. Используется при автоматическом создании подменю 
//                                           в форме объекта.
//
// Пример:
//
//	Вид = ВидыПодключаемыхКоманд.Добавить();
//	Вид.Имя         = "Мотиваторы";
//	Вид.ИмяПодменю  = "ПодменюМотиваторов";
//	Вид.Заголовок   = НСтр("ru = 'Мотиваторы'");
//	Вид.Картинка    = БиблиотекаКартинок.Информация;
//	Вид.Отображение = ОтображениеКнопки.КартинкаИТекст;
//	
&После("ПриОпределенииВидовПодключаемыхКоманд")
Процедура КА2_ПриОпределенииВидовПодключаемыхКоманд(ВидыПодключаемыхКоманд) Экспорт

	Вид = ВидыПодключаемыхКоманд.Добавить();
	Вид.Имя = "ОтборПоКаталогуАвтомобилей";
	Вид.ИмяПодменю = ПараметрыСеанса.КА2_ИмяГруппыФильтра;
	Вид.Заголовок = НСтр("ru = 'Отбор по каталогу автомобилей'");
	Вид.Картинка = БиблиотекаКартинок.АС2_ФильтрПоАвто;

	Вид = ВидыПодключаемыхКоманд.Добавить();
	Вид.Имя = "КаталогАвтомобилей";
	Вид.ИмяПодменю = ПараметрыСеанса.КА2_ПанельРазмещенияКнопки;
	Вид.Заголовок = НСтр("ru = 'Каталог автомобилей'");
	Вид.Картинка = БиблиотекаКартинок.АС2_ФильтрПоАвто;
	Вид.Отображение = ОтображениеКнопки.Картинка;

КонецПроцедуры

&После("ПриОпределенииСоставаНастроекПодключаемыхОбъектов")
Процедура КА2_ПриОпределенииСоставаНастроекПодключаемыхОбъектов(НастройкиПрограммногоИнтерфейса) Экспорт

	Настройка = НастройкиПрограммногоИнтерфейса.Добавить();
	Настройка.Ключ = "ОтборПоКаталогуАвтомобилей";
	Настройка.ОписаниеТипов = Новый ОписаниеТипов("Булево");
	Настройка.ВидыПодключаемыхОбъектов = "Обработка";

КонецПроцедуры

&После("ПриОпределенииКомандПодключенныхКОбъекту")
Процедура КА2_ПриОпределенииКомандПодключенныхКОбъекту(НастройкиФормы,
													   Источники,
													   ПодключенныеОтчетыИОбработки,
													   Команды) Экспорт

	Если НастройкиФормы.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаСписка" Тогда
		КА2_ПодключаемыеКомандыВызовСервера.ДобавитьКомандуОтборПоКаталогуАвтомобилей(Команды, НастройкиФормы);
		КА2_ПодключаемыеКомандыВызовСервера.ДобавитьКомандуДобавитьМодели(Команды, НастройкиФормы);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти