#Область ПрограммныйИнтерфейс


// Подключает и возвращает имя, под которым подключен внешний отчет или обработка.
//   После подключения отчет или обработка регистрируется в программе под определенным именем,
//   используя которое можно создавать объект или открывать формы отчета или обработки.
//
// Параметры:
//   Ссылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Подключаемая обработка.
//
// Возвращаемое значение: 
//   * Строка       - Имя подключенного отчета или обработки.
//   * Неопределено - Если передана некорректная ссылка.
//
// Важно:
//   Проверка функциональной опции "ИспользоватьДополнительныеОтчетыИОбработки"
//     должна выполняться вызывающим кодом.
//
Функция ПодключитьВнешнююОбработку(Ссылка) Экспорт
	
	СтандартнаяОбработка = Истина;
	Результат = Неопределено;
	
	//ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
	//	"СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки\ПриПодключенииВнешнейОбработки");
	//
	//Для каждого Обработчик Из ОбработчикиСобытия Цикл
	//	
	//	Обработчик.Модуль.ПриПодключенииВнешнейОбработки(Ссылка, СтандартнаяОбработка, Результат);
	//	
	//	Если Не СтандартнаяОбработка Тогда
	//		Возврат Результат;
	//	КонецЕсли;
	//	
	//КонецЦикла;
	
	// Проверка корректности переданных параметров.
	Если ТипЗнч(Ссылка) <> Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") 
		Или Ссылка = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// Подключение
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ИмяОбработки = ПолучитьИмяВременногоФайла();
		ХранилищеОбработки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ХранилищеОбработки");
		ДвоичныеДанные = ХранилищеОбработки.Получить();
		ДвоичныеДанные.Записать(ИмяОбработки);
		Возврат ИмяОбработки;
	#КонецЕсли
	
	Вид = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Вид");
	Если Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет
		Или Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		Менеджер = ВнешниеОтчеты;
	Иначе
		Менеджер = ВнешниеОбработки;
	КонецЕсли;
	
	ПараметрыЗапуска = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "БезопасныйРежим, ХранилищеОбработки");
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ПараметрыЗапуска.ХранилищеОбработки.Получить());
	
	//Если ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") Тогда
	//	
	//	БезопасныйРежим = РаботаВБезопасномРежимеСлужебный.РежимПодключенияВнешнегоМодуля(Ссылка);
	//	
	//	Если БезопасныйРежим = Неопределено Тогда
	//		БезопасныйРежим = Истина;
	//	КонецЕсли;
	//	
	//Иначе
		
		БезопасныйРежим = ПараметрыЗапуска.БезопасныйРежим;
		
		Если БезопасныйРежим Тогда
			ЗапросРазрешений = Новый Запрос(
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	ДополнительныеОтчетыИОбработкиРазрешения.НомерСтроки,
				|	ДополнительныеОтчетыИОбработкиРазрешения.ВидРазрешения
				|ИЗ
				|	Справочник.ДополнительныеОтчетыИОбработки.Разрешения КАК ДополнительныеОтчетыИОбработкиРазрешения
				|ГДЕ
				|	ДополнительныеОтчетыИОбработкиРазрешения.Ссылка = &Ссылка");
			ЗапросРазрешений.УстановитьПараметр("Ссылка", Ссылка);
			ЕстьРазрешений = Не ЗапросРазрешений.Выполнить().Пустой();
			
			РежимСовместимости = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "РежимСовместимостиРазрешений");
			Если РежимСовместимости = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_2_2
				И ЕстьРазрешений Тогда
				БезопасныйРежим = Ложь;
			КонецЕсли;
		КонецЕсли;
		
	//КонецЕсли;
	
	ЗаписатьПримечание(Ссылка, НСтр("ru = 'Подключение, БезопасныйРежим = ""%1"".'"), БезопасныйРежим);
	
	ИмяОбработки = Менеджер.Подключить(АдресВоВременномХранилище, , БезопасныйРежим);
	
	Возврат ИмяОбработки;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Регламентные задания

// Обработчик экземпляра регламентного задания ЗапускОбработок.
//   Запускает обработчик глобальной обработки по регламентному заданию,
//   с указанным идентификатором команды.
//
// Параметры:
//   ВнешняяОбработка     - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка выполняемой обработки.
//   ИдентификаторКоманды - Строка - Идентификатор выполняемой команды.
//
Процедура ВыполнитьОбработкуПоРегламентномуЗаданию(ВнешняяОбработка, ИдентификаторКоманды) Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ЗапускДополнительныхОбработок);
	
	// Запись журнала регистрации
	ЗаписатьИнформацию(ВнешняяОбработка, НСтр("ru = 'Команда %1: Запуск.'"), ИдентификаторКоманды);
	
	// Выполнение команды
	Попытка
		ВыполнитьКоманду(Новый Структура("ДополнительнаяОбработкаСсылка, ИдентификаторКоманды", ВнешняяОбработка, ИдентификаторКоманды), Неопределено);
	Исключение
		ЗаписатьОшибку(
			ВнешняяОбработка,
			НСтр("ru = 'Команда %1: Ошибка выполнения:%2'"),
			ИдентификаторКоманды,
			Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	// Запись журнала регистрации
	ЗаписатьИнформацию(ВнешняяОбработка, НСтр("ru = 'Команда %1: Завершение.'"), ИдентификаторКоманды);
	
КонецПроцедуры

// Выполняет команду обработки и возвращает результат ее выполнения.
//
// Важно: проверка функциональной опции "ИспользоватьДополнительныеОтчетыИОбработки"
// должна выполняться вызывающим кодом.
//
// Параметры:
//   ПараметрыКоманды - Структура - Параметры, с которыми выполняется команда.
//       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Элемент справочника.
//       * ИдентификаторКоманды - Строка - Имя выполняемой команды.
//       * ОбъектыНазначения    - Массив - Ссылки объектов, для которых выполняется обработка. Обязательный для
//                                         назначаемых обработок.
//   АдресРезультата - Строка - Необязательный. Адрес временного хранилища по которому будет размещен результат
//                              выполнения.
//
// Возвращаемое значение:
//   * Структура - Результат выполнения, который далее передается на клиент.
//   * Неопределено - Если был передан АдресРезультата.
//
Функция ВыполнитьКоманду(ПараметрыКоманды, АдресРезультата = Неопределено) Экспорт
	
	Если ТипЗнч(ПараметрыКоманды.ДополнительнаяОбработкаСсылка) <> Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки")
		Или ПараметрыКоманды.ДополнительнаяОбработкаСсылка = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВнешнийОбъект = ОбъектВнешнейОбработки(ПараметрыКоманды.ДополнительнаяОбработкаСсылка);
	ИдентификаторКоманды = ПараметрыКоманды.ИдентификаторКоманды;
	РезультатВыполнения = ВыполнитьКомандуВнешнегоОбъекта(ВнешнийОбъект, ИдентификаторКоманды, ПараметрыКоманды, АдресРезультата);
	
	Возврат РезультатВыполнения;
	
КонецФункции

// Выполняет команду дополнительного отчета или обработки из объекта.
Функция ВыполнитьКомандуВнешнегоОбъекта(ВнешнийОбъект, ИдентификаторКоманды, ПараметрыКоманды, АдресРезультата)
	
	СведенияОВнешнемОбъекте = ВнешнийОбъект.СведенияОВнешнейОбработке();
	
	ВидОбработки = ПолучитьВидОбработкиПоСтроковомуПредставлениюВида(СведенияОВнешнемОбъекте.Вид);
	
	ПередаватьПараметры = (
		СведенияОВнешнемОбъекте.Свойство("ВерсияБСП")
		И ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СведенияОВнешнемОбъекте.ВерсияБСП, "1.2.1.4") >= 0);
	
	РезультатВыполнения = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыКоманды, "РезультатВыполнения");
	Если ТипЗнч(РезультатВыполнения) <> Тип("Структура") Тогда
		ПараметрыКоманды.Вставить("РезультатВыполнения", Новый Структура());
	КонецЕсли;
	
	ОписаниеКоманды = СведенияОВнешнемОбъекте.Команды.Найти(ИдентификаторКоманды, "Идентификатор");
	Если ОписаниеКоманды = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Команда %1 не обнаружена!'"), ИдентификаторКоманды);
	КонецЕсли;
	
	ЭтоСценарийВБезопасномРежиме = (ОписаниеКоманды.Использование = "СценарийВБезопасномРежиме");
	
	ИзмененныеОбъекты = Неопределено;
	
	Если ВидОбработки = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка
		ИЛИ ВидОбработки = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		
		ВыполнитьКомандуДополнительногоОтчетаИлиОбработки(
			ВнешнийОбъект,
			ИдентификаторКоманды,
			?(ПередаватьПараметры, ПараметрыКоманды, Неопределено),
			ЭтоСценарийВБезопасномРежиме);
		
	ИначеЕсли ВидОбработки = Перечисления.ВидыДополнительныхОтчетовИОбработок.СозданиеСвязанныхОбъектов Тогда
		
//		ИзмененныеОбъекты = Новый Массив;
//		ВыполнитьКомандуСозданияСвязанныхОбъектов(
//			ВнешнийОбъект,
//			ИдентификаторКоманды,
//			?(ПередаватьПараметры, ПараметрыКоманды, Неопределено),
//			ПараметрыКоманды.ОбъектыНазначения,
//			ИзмененныеОбъекты,
//			ЭтоСценарийВБезопасномРежиме);
		
	ИначеЕсли ВидОбработки = Перечисления.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта
		ИЛИ ВидОбработки = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет
		ИЛИ ВидОбработки = Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма Тогда
		
		ОбъектыНазначения = Неопределено;
		ПараметрыКоманды.Свойство("ОбъектыНазначения", ОбъектыНазначения);
		
		Если ВидОбработки = Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма Тогда
			
			// Здесь только произвольная печать. Печать в MXL выполняется средствами подсистемы Печать.
//			ВыполнитьКомандуФормированияПечатнойФормы(
//				ВнешнийОбъект,
//				ИдентификаторКоманды,
//				?(ПередаватьПараметры, ПараметрыКоманды, Неопределено),
//				ОбъектыНазначения,
//				ЭтоСценарийВБезопасномРежиме);
			
		Иначе
			
//			ВыполнитьНазначаемуюКомандуДополнительногоОтчетаИлиОбработки(
//				ВнешнийОбъект,
//				ИдентификаторКоманды,
//				?(ПередаватьПараметры, ПараметрыКоманды, Неопределено),
//				ОбъектыНазначения,
//				ЭтоСценарийВБезопасномРежиме);
			
			Если ВидОбработки = Перечисления.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта Тогда
				ИзмененныеОбъекты = ОбъектыНазначения;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
//	ПараметрыКоманды.РезультатВыполнения.Вставить("ОповеститьФормы", СтандартныеПодсистемыСервер.ПодготовитьОповещениеФормОбИзменении(ИзмененныеОбъекты));
	
	Если ТипЗнч(АдресРезультата) = Тип("Строка") И ЭтоАдресВременногоХранилища(АдресРезультата) Тогда
		ПоместитьВоВременноеХранилище(ПараметрыКоманды.РезультатВыполнения, АдресРезультата);
	КонецЕсли;
	
	Возврат ПараметрыКоманды.РезультатВыполнения;
	
КонецФункции

// Возвращает объект внешнего отчета или обработки.
//
// Важно: проверка функциональной опции "ИспользоватьДополнительныеОтчетыИОбработки"
// должна выполняться вызывающим кодом.
//
// Параметры:
//   Ссылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Подключаемый отчет или обработка.
//
// Возвращаемое значение: 
//   * ВнешняяОбработкаОбъект - Объект подключенной обработки.
//   * ВнешнийОтчетОбъект     - Объект подключенного отчета.
//   * Неопределено           - Если передана некорректная ссылка.
//
Функция ОбъектВнешнейОбработки(Ссылка) Экспорт
	
	СтандартнаяОбработка = Истина;
	Результат = Неопределено;
	
	// типовые не запускаем
	//ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
	//	"СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки\ПриСозданииВнешнейОбработки");
	//
	//Для каждого Обработчик Из ОбработчикиСобытия Цикл
	//	
	//	Обработчик.Модуль.ПриСозданииВнешнейОбработки(Ссылка, СтандартнаяОбработка, Результат);
	//	
	//	Если Не СтандартнаяОбработка Тогда
	//		Возврат Результат;
	//	КонецЕсли;
	//	
	//КонецЦикла;
	
	// Подключение
	ИмяОбработки = ПодключитьВнешнююОбработку(Ссылка);
	
	// Проверка корректности переданных параметров.
	Если ИмяОбработки = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// Получение экземпляра объекта.
	Если Ссылка.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет
		ИЛИ Ссылка.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		Менеджер = ВнешниеОтчеты;
	Иначе
		Менеджер = ВнешниеОбработки;
	КонецЕсли;
	
	Возврат Менеджер.Создать(ИмяОбработки);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции.

// Формирует запрос для получения таблицы команд дополнительных отчетов или обработок.
//
// Параметры:
//   ВидОбработок - ПеречислениеСсылка.ВидыДополнительныхОтчетовИОбработок - Вид обработки.
//   ПолноеИмяИлиСсылкаРодителяИлиРаздела - СправочникСсылка.ИдентификаторыОбъектовМетаданных, Строка -
//       Объект метаданных (Ссылка или ПолноеИмя).
//       Для назначаемых обработок - справочника или документа.
//       Для глобальных обработок - подсистемы.
//   ЭтоФормаОбъекта - Булево - Необязательный.
//       Истина - для формы объекта.
//       Ложь - для формы списка.
//
// Возвращаемое значение: 
//   ТаблицаЗначений - Команды дополнительных отчетов или обработок.
//       * Ссылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка дополнительного отчета или обработки.
//       * Идентификатор - Строка - Идентификатор команды, как он задан разработчиком дополнительного объекта.
//       * ВариантЗапуска - ПеречислениеСсылка.СпособыВызоваДополнительныхОбработок -
//           Способ вызова команды дополнительного объекта.
//       * Представление - Строка - Наименование команды в пользовательском интерфейсе.
//       * ПоказыватьОповещение - Булево - Показывать оповещение пользователю после выполнения команды.
//       * Модификатор - Строка - Модификатор команды.
//
Функция НовыйЗапросПоДоступнымКомандам(ВидОбработок, ПолноеИмяИлиСсылкаРодителяИлиРаздела, ЭтоФормаОбъекта = Неопределено) Экспорт
	ЭтоГлобальныеОбработки = (
		ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет
		ИЛИ ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка);
	
	Если ТипЗнч(ПолноеИмяИлиСсылкаРодителяИлиРаздела) = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
		СсылкаРодителяИлиРаздела = ПолноеИмяИлиСсылкаРодителяИлиРаздела;
	Иначе
		СсылкаРодителяИлиРаздела = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяИлиСсылкаРодителяИлиРаздела);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	// Запросы принципиально отличаются для глобальных обработок и назначаемых.
	Если ЭтоГлобальныеОбработки Тогда
		ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	БыстрыйДоступ.ДополнительныйОтчетИлиОбработка КАК Ссылка,
		|	БыстрыйДоступ.ИдентификаторКоманды
		|ПОМЕСТИТЬ втБыстрыйДоступ
		|ИЗ
		|	РегистрСведений.ПользовательскиеНастройкиДоступаКОбработкам КАК БыстрыйДоступ
		|ГДЕ
		|	БыстрыйДоступ.Пользователь = &ТекущийПользователь
		|	И БыстрыйДоступ.Доступно = ИСТИНА
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаБыстрыйДоступ.Ссылка,
		|	ТаблицаБыстрыйДоступ.ИдентификаторКоманды
		|ПОМЕСТИТЬ втСсылкиИКоманды
		|ИЗ
		|	втБыстрыйДоступ КАК ТаблицаБыстрыйДоступ
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки КАК ДопОтчетыИОбработки
		|		ПО ТаблицаБыстрыйДоступ.Ссылка = ДопОтчетыИОбработки.Ссылка
		|			И (ДопОтчетыИОбработки.ПометкаУдаления = ЛОЖЬ)
		|			И (ДопОтчетыИОбработки.Вид = &Вид)
		|			И (ДопОтчетыИОбработки.Публикация = &Публикация)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Разделы КАК ТаблицаРазделы
		|		ПО ТаблицаБыстрыйДоступ.Ссылка = ТаблицаРазделы.Ссылка
		|			И (ТаблицаРазделы.Раздел = &СсылкаРаздела)
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ДопОтчетыИОбработки.Ссылка,
		|	ДополнительныеОтчетыИОбработкиКоманды.Идентификатор
		|ИЗ
		|	Справочник.ДополнительныеОтчетыИОбработки.Команды КАК ДополнительныеОтчетыИОбработкиКоманды
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки КАК ДопОтчетыИОбработки
		|		ПО ДополнительныеОтчетыИОбработкиКоманды.Ссылка = ДопОтчетыИОбработки.Ссылка
		|			И (ДопОтчетыИОбработки.ПометкаУдаления = ЛОЖЬ)
		|			И (ДопОтчетыИОбработки.Вид = &Вид)
		|			И (ДопОтчетыИОбработки.Публикация = &Публикация)
		|			И (ДополнительныеОтчетыИОбработкиКоманды.ПросмотрВсе = ИСТИНА)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Разделы КАК ТаблицаРазделы
		|		ПО ДополнительныеОтчетыИОбработкиКоманды.Ссылка = ТаблицаРазделы.Ссылка
		|			И (ТаблицаРазделы.Раздел = &СсылкаРаздела)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаКоманды.Ссылка,
		|	ТаблицаКоманды.Идентификатор,
		|	ТаблицаКоманды.ЗаменяемыеКоманды,
		|	ТаблицаКоманды.ВариантЗапуска,
		|	ТаблицаКоманды.ИмяФормы,
		|	ТаблицаКоманды.Представление КАК Представление,
		|	ТаблицаКоманды.ПоказыватьОповещение,
		|	ТаблицаКоманды.Модификатор,
		|	ВЫБОР
		|		КОГДА (ВЫРАЗИТЬ(ТаблицаКоманды.Описание КАК СТРОКА(150))) = """"
		|			ТОГДА ТаблицаКоманды.Ссылка.Информация
		|		ИНАЧЕ ТаблицаКоманды.Описание
		|	КОНЕЦ КАК Описание,
		|	ТаблицаКоманды.Ссылка.Версия КАК Версия
		|ИЗ
		|	втСсылкиИКоманды КАК ТаблицаСсылкиИКоманды
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Команды КАК ТаблицаКоманды
		|		ПО ТаблицаСсылкиИКоманды.Ссылка = ТаблицаКоманды.Ссылка
		|			И ТаблицаСсылкиИКоманды.ИдентификаторКоманды = ТаблицаКоманды.Идентификатор
		|			И (ТаблицаКоманды.Скрыть = ЛОЖЬ)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Представление";
		
		Запрос.УстановитьПараметр("СсылкаРаздела", СсылкаРодителяИлиРаздела);
		
	Иначе
		
		ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ТаблицаНазначение.Ссылка
		|ПОМЕСТИТЬ втСсылки
		|ИЗ
		|	Справочник.ДополнительныеОтчетыИОбработки.Назначение КАК ТаблицаНазначение
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки КАК ДопОтчетыИОбработки
		|		ПО (ТаблицаНазначение.ОбъектНазначения = &СсылкаРодителя)
		|			И ТаблицаНазначение.Ссылка = ДопОтчетыИОбработки.Ссылка
		|			И (ДопОтчетыИОбработки.ПометкаУдаления = ЛОЖЬ)
		|			И (ДопОтчетыИОбработки.Вид = &Вид)
		|			И (ДопОтчетыИОбработки.Публикация = &Публикация)
		|			И (ДопОтчетыИОбработки.ИспользоватьДляФормыСписка = ИСТИНА)
		|			И (ДопОтчетыИОбработки.ИспользоватьДляФормыОбъекта = ИСТИНА)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаКоманды.Ссылка,
		|	ТаблицаКоманды.Идентификатор,
		|	ТаблицаКоманды.ЗаменяемыеКоманды,
		|	ТаблицаКоманды.ВариантЗапуска,
		|	ТаблицаКоманды.Представление КАК Представление,
		|	ТаблицаКоманды.ПоказыватьОповещение,
		|	ТаблицаКоманды.Модификатор
		|ИЗ
		|	втСсылки КАК ТаблицаСсылки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Команды КАК ТаблицаКоманды
		|		ПО ТаблицаСсылки.Ссылка = ТаблицаКоманды.Ссылка
		|			И (ТаблицаКоманды.Скрыть = ЛОЖЬ)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Представление";
		
		Запрос.УстановитьПараметр("СсылкаРодителя", СсылкаРодителяИлиРаздела);
		
		// Отключение отборов по форме списка и объекта.
		Если ЭтоФормаОбъекта <> Истина Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И (ДопОтчетыИОбработки.ИспользоватьДляФормыОбъекта = ИСТИНА)", "");
		КонецЕсли;
		Если ЭтоФормаОбъекта <> Ложь Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И (ДопОтчетыИОбработки.ИспользоватьДляФормыСписка = ИСТИНА)", "");
		КонецЕсли;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Вид", ВидОбработок);
	Запрос.УстановитьПараметр("ТекущийПользователь", ПользователиКлиентСервер.АвторизованныйПользователь());
	Запрос.УстановитьПараметр("Публикация",Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос;
КонецФункции

// Запись ошибки в журнал регистрации по дополнительному отчету или обработке.
Процедура ЗаписатьОшибку(Ссылка, ТекстСообщения, Реквизит1 = Неопределено, Реквизит2 = Неопределено, Реквизит3 = Неопределено) Экспорт
	Уровень = УровеньЖурналаРегистрации.Ошибка;
	ЗаписатьВЖурнал(Уровень, Ссылка, ТекстСообщения, Реквизит1, Реквизит2, Реквизит3);
КонецПроцедуры


// Запись информации в журнал регистрации по дополнительному отчету или обработке.
Процедура ЗаписатьИнформацию(Ссылка, ТекстСообщения, Реквизит1 = Неопределено, Реквизит2 = Неопределено, Реквизит3 = Неопределено) Экспорт
	Уровень = УровеньЖурналаРегистрации.Информация;
	ЗаписатьВЖурнал(Уровень, Ссылка, ТекстСообщения, Реквизит1, Реквизит2, Реквизит3);
КонецПроцедуры

// Запись примечания в журнал регистрации по дополнительному отчету или обработке.
Процедура ЗаписатьПримечание(Ссылка, ТекстСообщения, Реквизит1 = Неопределено, Реквизит2 = Неопределено, Реквизит3 = Неопределено) Экспорт
	Уровень = УровеньЖурналаРегистрации.Примечание;
	ЗаписатьВЖурнал(Уровень, Ссылка, ТекстСообщения, Реквизит1, Реквизит2, Реквизит3);
КонецПроцедуры

// Запись события в журнал регистрации по дополнительному отчету или обработке.
Процедура ЗаписатьВЖурнал(Уровень, Ссылка, Текст, Параметр1, Параметр2, Параметр3)
	Текст = СтрЗаменить(Текст, "%1", Параметр1); // Переход на СтрШаблон невозможен.
	Текст = СтрЗаменить(Текст, "%2", Параметр2);
	Текст = СтрЗаменить(Текст, "%3", Параметр3);
	ЗаписьЖурналаРегистрации(
		ДополнительныеОтчетыИОбработкиКлиентСервер.НаименованиеПодсистемы(Ложь),
		Уровень,
		Метаданные.Справочники.ДополнительныеОтчетыИОбработки,
		Ссылка,
		Текст);
КонецПроцедуры

#КонецОбласти


#Область РегламентныеЗадания

// Преобразует вид дополнительных отчетов или обработок из строковой константы в ссылку перечисления.
//
// Параметры:
//   СтроковоеПредставление - Строка - Строковое представление вида.
//
// Возвращаемое значение: 
//   ПеречислениеСсылка.ВидыДополнительныхОтчетовИОбработок - Ссылка вида.
//
Функция ПолучитьВидОбработкиПоСтроковомуПредставлениюВида(СтроковоеПредставление) Экспорт
	
	Если СтроковоеПредставление = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиЗаполнениеОбъекта() Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта;
	ИначеЕсли СтроковоеПредставление = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиОтчет() Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет;
	ИначеЕсли СтроковоеПредставление = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиПечатнаяФорма() Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма;
	ИначеЕсли СтроковоеПредставление = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиСозданиеСвязанныхОбъектов() Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.СозданиеСвязанныхОбъектов;
	ИначеЕсли СтроковоеПредставление = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиШаблонСообщения() Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.ШаблонСообщения;
	ИначеЕсли СтроковоеПредставление = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка() Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка;
	ИначеЕсли СтроковоеПредставление = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительныйОтчет() Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет;
	КонецЕсли;
	
КонецФункции

// Для внутреннего использования.
Процедура ВыполнитьКомандуДополнительногоОтчетаИлиОбработки(ВнешнийОбъект, Знач ИдентификаторКоманды, ПараметрыКоманды, Знач СценарийВБезопасномРежиме = Ложь)
	
//	Если СценарийВБезопасномРежиме Тогда
		
//		ВыполнитьСценарийВБезопасномРежиме(ВнешнийОбъект, ПараметрыКоманды);
		
//	Иначе
		
		Если ПараметрыКоманды = Неопределено Тогда
			
			ВнешнийОбъект.ВыполнитьКоманду(ИдентификаторКоманды);
			
		Иначе
			
			ВнешнийОбъект.ВыполнитьКоманду(ИдентификаторКоманды, ПараметрыКоманды);
			
		КонецЕсли;
		
//	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти