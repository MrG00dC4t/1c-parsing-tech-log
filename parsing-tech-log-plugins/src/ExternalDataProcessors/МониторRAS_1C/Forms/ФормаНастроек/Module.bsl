&НаКлиенте
Перем СтарыеКолонки;
&НаКлиенте
Перем СписокИнформационныхБаз;
&НаКлиенте
Перем СписокПроцессов;
&НаКлиенте
Перем СоответсвиеСинонимовСвойств;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Замер) Тогда
		ЗамерВходящий = Параметры.Замер;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ЗамерВходящий) Тогда
		Замер = ЗамерВходящий;
	КонецЕсли;

	СистемнаяИнфомрация = ПолучитьСистемнуюИнформациюСервера(); 
	
	Если НЕ ЗначениеЗаполнено(ВерсияПлатформы1С) Тогда
		ВерсияПлатформы1С = СистемнаяИнфомрация.ВерсияПриложения;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПутьКИсполняемомуФайлуRAC) Тогда
		ПутьКИсполняемомуФайлуRAC = ПолучитьПутьКФайлуRacWindows(ВерсияПлатформы1С,СистемнаяИнфомрация.ТипПлатформы);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПортRAS) Тогда
		ПортRAS = 1545;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(РежимОбработкиДанных) Тогда
		РежимОбработкиДанных = "НеИспользовать";
	КонецЕсли;	
	
	Элементы.КодировкаТекстаФайла.СписокВыбора.Добавить(КодировкаТекста.Системная);
	Элементы.КодировкаТекстаФайла.СписокВыбора.Добавить(КодировкаТекста.ANSI);
	Элементы.КодировкаТекстаФайла.СписокВыбора.Добавить(КодировкаТекста.OEM);
	Элементы.КодировкаТекстаФайла.СписокВыбора.Добавить(КодировкаТекста.UTF8);
	Элементы.КодировкаТекстаФайла.СписокВыбора.Добавить(КодировкаТекста.UTF16);
	Элементы.КодировкаТекстаФайла.СписокВыбора.Добавить("windows-1251");
	Элементы.КодировкаТекстаФайла.СписокВыбора.Добавить("windows-1250");
	Элементы.КодировкаТекстаФайла.СписокВыбора.Добавить("cp866");
	Элементы.КодировкаТекстаФайла.СписокВыбора.Добавить("KOI8-R");
	
	Элементы.Корзинаfunc.КнопкаВыпадающегоСписка = Истина;
	Элементы.Корзинаfunc.КнопкаОчистки = Истина;
	Элементы.Корзинаfunc.СписокВыбора.Добавить("","нет функции");
	Элементы.Корзинаfunc.СписокВыбора.Добавить("max","максимум");
	Элементы.Корзинаfunc.СписокВыбора.Добавить("min","минимум");
	Элементы.Корзинаfunc.СписокВыбора.Добавить("avg","среднее");
	Элементы.Корзинаfunc.СписокВыбора.Добавить("count","количество");
	Элементы.Корзинаfunc.СписокВыбора.Добавить("sum","сумма");
	Элементы.Корзинаfunc.СписокВыбора.Добавить("count ЗначениеЗаполнено","количество ЗначениеЗаполнено");
	
	
	СоответсвиеСинонимовСвойств = ПолучитьСоответсвиеСинонимовСвойств();
	
	Если НЕ ЗначениеЗаполнено(Список) Тогда
		Список="infobase";
	КонецЕсли;
		
	Элементы.Список.СписокВыбора.Добавить("infobase","инф. базы");
	Элементы.Список.СписокВыбора.Добавить("server","сервера");
	Элементы.Список.СписокВыбора.Добавить("process","процессы");
	Элементы.Список.СписокВыбора.Добавить("process licenses","процессы лицензии");
	Элементы.Список.СписокВыбора.Добавить("connection","соединения");
	Элементы.Список.СписокВыбора.Добавить("session","сеансы");
	Элементы.Список.СписокВыбора.Добавить("session licenses","сеансы лицензии");
	
	Если ЗначениеЗаполнено(Замер) Тогда
		Попытка
			ЗагрузитьНастройки(Неопределено);
		Исключение
		КонецПопытки;
	КонецЕсли;
		
КонецПроцедуры






#Область РаботаСохранениеЗагрузкаНастроек

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	мНастройка = новый Структура();
	мНастройка.Вставить("КодировкаТекстаФайла",КодировкаТекстаФайла);
	мНастройка.Вставить("ВерсияПлатформы1С",ВерсияПлатформы1С);
	мНастройка.Вставить("ИмяСервера",ИмяСервера);
	мНастройка.Вставить("ПортRAS",ПортRAS);
	мНастройка.Вставить("ПутьКИсполняемомуФайлуRAC",ПутьКИсполняемомуФайлуRAC);
	мНастройка.Вставить("РежимОбработкиДанных",РежимОбработкиДанных);
	мНастройка.Вставить("СохранятьВсеДетальныеЗаписи",СохранятьВсеДетальныеЗаписи);
	мНастройка.Вставить("Корзина",новый Массив);
	мНастройка.Вставить("Кластеры",новый Массив);
	мНастройка.Вставить("Суждения",новый Массив);
	
	Для каждого стр из Корзина Цикл
		Данные = новый Структура("cluster,type,name,list,func,synonim");
		ЗаполнитьЗначенияСвойств(Данные,стр);
		мНастройка.Корзина.Добавить(Данные);
	КонецЦикла;
	
	Для каждого стр из ТаблицаКластеров Цикл
		Данные = новый Структура("name,cluster,cluster_user,cluster_pwd,server,port_ras");
		ЗаполнитьЗначенияСвойств(Данные,стр);
		мНастройка.Кластеры.Добавить(Данные);
	КонецЦикла;

	Для каждого стр из ТаблицаСуждений Цикл
		Данные = новый Структура("cluster,type,name,list,func,synonim,key,invert,warning_from,warning_to,attention_from,attention_to");
		ЗаполнитьЗначенияСвойств(Данные,стр);
		мНастройка.Суждения.Добавить(Данные);
	КонецЦикла;
		
	УправлениеХранилищемНастроекВызовСервера.ЗаписатьДанныеВБезопасноеХранилищеРасширенный(Замер,мНастройка,"Настройка загрузки данных консоль кластера через RAS");
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНастройки(Команда)
	мНастройка = УправлениеХранилищемНастроекВызовСервера.ДанныеИзБезопасногоХранилища(Замер);
	Если мНастройка<>Неопределено Тогда
		КодировкаТекстаФайла = мНастройка.КодировкаТекстаФайла;
		ВерсияПлатформы1С = мНастройка.ВерсияПлатформы1С;
		ИмяСервера = мНастройка.ИмяСервера;
		ПортRAS = мНастройка.ПортRAS;
		РежимОбработкиДанных = мНастройка.РежимОбработкиДанных;
		ПутьКИсполняемомуФайлуRAC = мНастройка.ПутьКИсполняемомуФайлуRAC;
		СохранятьВсеДетальныеЗаписи = мНастройка.СохранятьВсеДетальныеЗаписи;

		Корзина.Очистить();
		Для каждого стр из мНастройка.Корзина Цикл
			стр_н = Корзина.Добавить();
			ЗаполнитьЗначенияСвойств(стр_н,стр);
		КонецЦикла;
		
		ТаблицаКластеров.Очистить();
		Для каждого стр из мНастройка.Кластеры Цикл
			стр_н = ТаблицаКластеров.Добавить();
			ЗаполнитьЗначенияСвойств(стр_н,стр);
		КонецЦикла;
		
		Попытка
			ТаблицаСуждений.Очистить();
			Для каждого стр из мНастройка.Суждения Цикл
				стр_н = ТаблицаСуждений.Добавить();
				ЗаполнитьЗначенияСвойств(стр_н,стр);
			КонецЦикла;			
		Исключение
		КонецПопытки;

	КонецЕсли;
КонецПроцедуры

#КонецОбласти 

#Область КомандыФормы

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	СписокRAS = СтрЗаменить(Список," licenses","");
	ПолучтьСписокНаКлиенте(СписокRAS,Найти(Список,"licenses"));
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок(Команда)
	СписокПриИзменении(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСписокКластеров(Команда)
	мПараметры = СформироватьСтруктуруЗапроса(Неопределено);
	ПолучитьСписокКластеровНаСервере(мПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРаботуСенаса(Команда)
	
	ТекущиеДанные = Элементы.ТаблицаДанных.ТекущиеДанные;
	ТекущиеДанныеКластеров = Элементы.ТаблицаКластеров.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено ИЛИ ТекущиеДанныеКластеров=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтарыеКолонки=Неопределено Тогда
		СтарыеКолонки = новый Массив;
	КонецЕсли;		
	
	session = "";
	// найдем поле сессия
	Для каждого стр из СтарыеКолонки Цикл
		Если стр.Ключ="session" Тогда
			session = ТекущиеДанные[стр.Имя];
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если session="" Тогда
		Возврат;
	КонецЕсли;
	
	мПараметры = СформироватьСтруктуруЗапроса(ТекущиеДанныеКластеров);
	мПараметры.Вставить("session",session);
	СтруктураДанныхОтвета = ЗавершитьРаботуСенасаНаСервере(мПараметры);
	
	ДлительностьЗапроса = СтруктураДанныхОтвета.Длительность;
	
	СоздатьИОбновитьКолонки(СтруктураДанныхОтвета.МассивСоответствиеДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВКорзину(Команда)
	ТекущиеДанные = Элементы.ТаблицаСвойств.ТекущиеДанные;
	ДобавитьВКорзинуСтроку(ТекущиеДанные);	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВсеВКорзину(Команда)
	Для каждого стр из ТаблицаСвойств Цикл
		ДобавитьВКорзинуСтроку(стр);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСвойствВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.ТаблицаСвойств.ТекущиеДанные;
	ДобавитьВКорзинуСтроку(ТекущиеДанные);
КонецПроцедуры
#КонецОбласти

#Область ФункцииПолученияДанныхСписокв

&НаСервере
Функция ПолучитьСписок(мПараметры,list,licenses=Ложь)
	РеквизитОбъект = РеквизитФормыВЗначение("Объект");
	возврат РеквизитОбъект.ПолучитьСписок(мПараметры,list,licenses)
КонецФункции

&НаСервере
Процедура ПолучитьСписокКластеровНаСервере(мПараметры)
	
	РеквизитОбъект = РеквизитФормыВЗначение("Объект");
	СтруктураДанныхОтвета = РеквизитОбъект.ПолучитьСписок(мПараметры,"cluster");
	
	Для каждого стр из СтруктураДанныхОтвета.МассивСоответствиеДанных Цикл
		мОтбор = новый Структура("cluster",стр.Получить("cluster"));
		н_строки = ТаблицаКластеров.НайтиСтроки(мОтбор);
		// добавим если не было ранее
		Если н_строки.Количество()=0 Тогда
			стр_н = ТаблицаКластеров.Добавить();
		Иначе
			стр_н = н_строки[0];
		КонецЕсли;
		стр_н.cluster = стр.Получить("cluster"); 
		стр_н.name = стр.Получить("name");
		стр_н.server = ИмяСервера;
		стр_н.port_ras = ПортRAS;
	КонецЦикла;
	
КонецПроцедуры   

&НаКлиенте
Процедура ПолучтьСписокНаКлиенте(list,licenses=Ложь)
	ТекущиеДанные = Элементы.ТаблицаКластеров.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтарыеКолонки=Неопределено Тогда
		СтарыеКолонки = новый Массив;
	КонецЕсли;	
	
	мПараметры = СформироватьСтруктуруЗапроса(ТекущиеДанные);

	СтруктураДанныхОтвета = ПолучитьСписок(мПараметры,list,licenses);
	
	Если list="infobase" Тогда
		СписокИнформационныхБаз = СтруктураДанныхОтвета.МассивСоответствиеДанных;
	КонецЕсли;
		
	ДлительностьЗапроса = СтруктураДанныхОтвета.Длительность;
	
	ДобавитьПредставлениеInfobase(СтруктураДанныхОтвета.МассивСоответствиеДанных);
	
	СоздатьИОбновитьКолонки(СтруктураДанныхОтвета.МассивСоответствиеДанных);
	
	ЗаполнитьТаблицуСвойств(СтруктураДанныхОтвета.МассивСоответствиеДанных,list);

	ВычислитьФункцииАгрегации(СтруктураДанныхОтвета.МассивСоответствиеДанных,list);
	
КонецПроцедуры

&НаСервере
Функция ЗавершитьРаботуСенасаНаСервере(мПараметры)
	РеквизитОбъект = РеквизитФормыВЗначение("Объект");
	возврат РеквизитОбъект.ЗавершитьСеансПользователя(мПараметры)
КонецФункции

&НаСервере
Процедура ВычислитьФункцииАгрегации(Знач МассивСоответствиеДанных,Знач list)
	
	РеквизитОбъект = РеквизитФормыВЗначение("Объект");
	
	// очистили
	ТаблицаАгрегацииДанных.Очистить();	
	
	МассивСтруктурАгрегацииДанных = РеквизитОбъект.ВычислитьФункцииАгрегации(МассивСоответствиеДанных, Корзина, list);
	
	Для каждого стр из МассивСтруктурАгрегацииДанных Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаАгрегацииДанных.Добавить(),стр);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредставлениеInfobase(Знач МассивСоответствиеДанных)
	
	Перем Соответсвие, стр, эл;
	
	// добавим представление инфобазы
	Если НЕ СписокИнформационныхБаз=Неопределено Тогда
		
		Соответсвие = новый Соответствие;
		Для каждого стр из СписокИнформационныхБаз Цикл
			Соответсвие.Вставить(стр.Получить("infobase"),стр);
		КонецЦикла;
		
		Для каждого стр из МассивСоответствиеДанных Цикл
			эл = Соответсвие.Получить(стр.Получить("infobase"));
			Если Не эл=Неопределено Тогда 
				стр.Вставить("infobase-name",эл.Получить("name"));
			Иначе
				стр.Вставить("infobase-name","");
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеФункции

&НаСервере
Функция ПолучитьСистемнуюИнформациюСервера()
	СисИнф = новый СистемнаяИнформация;
	Возврат новый Структура("ВерсияОС,ТипПлатформы,ВерсияПриложения",СисИнф.ВерсияОС,Строка(СисИнф.ТипПлатформы),СисИнф.ВерсияПриложения);
КонецФункции

&НаСервере
Функция ПолучитьПутьКФайлуRacWindows(Знач Версия1С,Знач ТипПлатформы1С=Неопределено,Знач Предприятие32=Ложь)
	
	Это64Бит = Ложь;
	ФайлНайден = Ложь;
	Шаблон32 = "c:\Program Files (x86)\1cv8\"+Версия1С+"\bin\rac.exe";
	Шаблон64 = "c:\Program Files\1cv8\"+Версия1С+"\bin\rac.exe";
	
	Если ТипПлатформы1С=Строка(ТипПлатформы.Windows_x86_64) ИЛИ
		ТипПлатформы1С=Строка(ТипПлатформы.Linux_x86_64) ИЛИ ТипПлатформы1С=Строка(ТипПлатформы.MacOS_x86_64) Тогда
		Это64Бит = Истина;
	КонецЕсли;
	
	// попрбуем найти файл
	Файл = новый Файл(Шаблон64);
	Если Файл.Существует() Тогда
		ПутьКфацлу = Шаблон64;
		ФайлНайден = Истина;
	КонецЕсли;
	
	Файл = новый Файл(Шаблон32);
	Если Файл.Существует() Тогда
		ПутьКфацлу = Шаблон32;
		ФайлНайден = Истина;
	КонецЕсли;
	
	Если НЕ ФайлНайден=Истина Тогда
		// Так обычно не делают, но проверим на такую ситуацию
		Если Это64Бит=Истина И Предприятие32=Истина Тогда
			ПутьКфацлу = Шаблон32;
		Иначе
			ПутьКфацлу = Шаблон64;
		КонецЕсли;	
	КонецЕсли;

	Возврат ПутьКфацлу;
КонецФункции

&НаКлиенте
Процедура ЗаполнитьТаблицуСвойств(Знач МассивСоответствиеДанных,Знач list)
	
	Перем стр, стр_н;
	
	ТаблицаСвойств.Очистить();
	
	Для каждого стр из МассивСоответствиеДанных Цикл
		Для каждого эл из стр Цикл
			стр_н = ТаблицаСвойств.Добавить();
			стр_н.name = эл.Ключ;
			стр_н.list = list; 
			стр_н.type = ТипЗнч(эл.Значение); 
			стр_н.cluster = cluster;
			стр_н.synonim = СоответсвиеСинонимовСвойств.Получить(эл.Ключ);
		КонецЦикла;
		Прервать;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Функция СформироватьСтруктуруЗапроса(Знач ТекущиеДанные)
	
	мПараметры = новый Структура();
	мПараметры.Вставить("ПутьКИсполняемомуФайлуRAC",ПутьКИсполняемомуФайлуRAC);
	мПараметры.Вставить("КодировкаТекстаФайла",КодировкаТекстаФайла);
	Если НЕ ТекущиеДанные=Неопределено Тогда
		мПараметры.Вставить("server",ТекущиеДанные.server);
		мПараметры.Вставить("port_ras",ТекущиеДанные.port_ras);
		мПараметры.Вставить("cluster",ТекущиеДанные.cluster);
		мПараметры.Вставить("cluster_user",ТекущиеДанные.cluster_user);
		мПараметры.Вставить("cluster_pwd",ТекущиеДанные.cluster_pwd);
		cluster = ТекущиеДанные.cluster;
	Иначе
		мПараметры.Вставить("server",ИмяСервера);
		мПараметры.Вставить("port_ras",ПортRAS);
		мПараметры.Вставить("cluster","");
		мПараметры.Вставить("cluster_user","");
		мПараметры.Вставить("cluster_pwd","");
		cluster = "";
	КонецЕсли;
	
	Возврат мПараметры;

КонецФункции

&НаКлиенте
Процедура СоздатьИОбновитьКолонки(Знач МассивСоответствиеДанных)
	
	Перем ИмяКолонки, Колонки, КС, КЧ, МассивТипов, ОписаниеТипов, ОписаниеЧисло, стр, стр_н, ш, элем;
	
	Колонки = новый Массив;
	МассивТипов = новый Массив;
	МассивТипов.Добавить(Тип("Строка"));
	МассивТипов.Добавить(Тип("Число"));
	МассивТипов.Добавить(Тип("Булево"));
	МассивТипов.Добавить(Тип("Дата"));
	КС = Новый КвалификаторыСтроки(200);
	КЧ = Новый КвалификаторыЧисла(20,3);
	ОписаниеТипов = Новый ОписаниеТипов(МассивТипов, , ,КЧ, КС);
	ОписаниеЧисло = Новый ОписаниеТипов("Число", , ,КЧ);	
	
	Колонки = новый массив;
	
	Для каждого элем из МассивСоответствиеДанных Цикл	
		
		ш=0;
		Для каждого стр из элем Цикл
			ИмяКолонки = "колонка_"+XMLСтрока(ш);
			Заголовок = стр.Ключ;
			Синоним = СоответсвиеСинонимовСвойств.Получить(Заголовок);
			Если НЕ Синоним=Неопределено Тогда
				Заголовок = Синоним;
			КонецЕсли;
			Колонки.Добавить(новый Структура("Имя,Ключ,ТипСтрокой,ТипЗначения,Ширина,Заголовок,ИмяКолонки,ИмяСледующегоЭлемента,ТолькоПросмотр",ИмяКолонки,стр.Ключ,Строка(ТипЗнч(стр.Значение)),ОписаниеТипов,10,Заголовок,ИмяКолонки,Неопределено,Истина));
			ш=ш+1;
		КонецЦикла;
		прервать;
		
	КонецЦикла;
	
	// создадим динамически таблицу 
	Попытка
		СоздатьДинамическиеКолонкиТаблицы("ТаблицаДанных",Колонки,СтарыеКолонки);
	Исключение
	КонецПопытки;
	
	
	СтарыеКолонки = Колонки;	
	
	ТаблицаДанных.Очистить();
	
	Для каждого элем из МассивСоответствиеДанных Цикл
		стр_н = ТаблицаДанных.Добавить();
		ш=0;
		Для каждого стр из элем Цикл
			ИмяКолонки = "колонка_"+XMLСтрока(ш);
			стр_н[ИмяКолонки]=стр.Значение;
			ш=ш+1;
		КонецЦикла;	
	КонецЦикла;

	Элементы.Декорация1.Видимость = ТаблицаДанных.Количество()=0;
	
КонецПроцедуры

&НаКлиенте
Процедура ВерсияПлатформы1СПриИзменении(Элемент)
	СистемнаяИнфомрация = ПолучитьСистемнуюИнформациюСервера(); 
	ПутьКИсполняемомуФайлуRAC = ПолучитьПутьКФайлуRacWindows(ВерсияПлатформы1С,Строка(СистемнаяИнфомрация.ТипПлатформы));
КонецПроцедуры

// Процедура - Создать динамические колонки таблицы
//
// Параметры:
//  ИмяТаблицы					 - строка	 - имя таблицы на форме строкой
//  МассивСтруктурКолонок		 - 	 - описание создаваемых колонок
//  МассивСтруктурТекущихКолонок - 	 - описание текущих колонок для удаления из текущей таблицы
&НаСервере
Процедура СоздатьДинамическиеКолонкиТаблицы(ИмяТаблицы,МассивСтруктурКолонок,МассивСтруктурТекущихКолонок,КромеИменКолонок="")
	
	МассивУдаляемыхЭлементов = новый Массив;
	МассивДобавляемыхЭлементов = новый Массив;
	
	Для каждого Колонка из МассивСтруктурТекущихКолонок Цикл
		Если Найти(КромеИменКолонок,Колонка.Имя) Тогда
			Продолжить;
		КонецЕсли;
		МассивУдаляемыхЭлементов.Добавить(ИмяТаблицы+"."+Колонка.Имя);
		Элементы.Удалить(Элементы[ИмяТаблицы+Колонка.Имя]);    
	КонецЦикла;   
	
	МассивТипов = новый Массив;
	МассивТипов.Добавить(Тип("ТаблицаЗначений"));           
	ОписаниеТиповТаблица = Новый ОписаниеТипов(МассивТипов);
	МассивТипов = новый Массив;
	МассивТипов.Добавить(Тип("Строка"));          
	ОписаниеТиповСтрока = Новый ОписаниеТипов(МассивТипов);
	
	Для каждого Колонка из МассивСтруктурКолонок Цикл
		Если Найти(КромеИменКолонок,Колонка.Имя) Тогда
			Продолжить;
		КонецЕсли;
		Если Колонка.ТипЗначения = ОписаниеТиповТаблица Тогда
			ОписаниеТипов = ОписаниеТиповСтрока;
		Иначе
			ОписаниеТипов = новый ОписаниеТипов(Колонка.ТипЗначения);
		КонецЕсли;
		НовыйРеквизит = Новый РеквизитФормы(Колонка.Имя, ОписаниеТипов, ИмяТаблицы, Колонка.Имя, Ложь);
		МассивДобавляемыхЭлементов.Добавить(НовыйРеквизит);
	КонецЦикла;
	
	Если МассивДобавляемыхЭлементов.Количество()=0 И МассивУдаляемыхЭлементов.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	ЭтаФорма.ИзменитьРеквизиты(МассивДобавляемыхЭлементов,МассивУдаляемыхЭлементов);
	
	Для каждого Колонка из МассивСтруктурКолонок Цикл                       
		Если Найти(КромеИменКолонок,Колонка.Имя) Тогда
			Продолжить;
		КонецЕсли;
		СледующийЭлемент = Неопределено;
		Если НЕ Колонка.ИмяСледующегоЭлемента=Неопределено Тогда
			СледующийЭлемент = Элементы.Найти(Колонка.ИмяСледующегоЭлемента);
		КонецЕсли;
		НовыйЭлемент = Элементы.Вставить(Элементы[ИмяТаблицы].Имя+Колонка.Имя, Тип("Полеформы"), Элементы[ИмяТаблицы],СледующийЭлемент);
		Если Колонка.ТипСтрокой="Булево" Или  Колонка.ТипСтрокой="Boolean"Тогда
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеФлажка;
		Иначе
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
			НовыйЭлемент.Высота = 0;
			НовыйЭлемент.Ширина = Колонка.Ширина;                
		КонецЕсли;
		НовыйЭлемент.Видимость = Истина;
		НовыйЭлемент.Доступность = Истина;
		НовыйЭлемент.ТолькоПросмотр = Колонка.ТолькоПросмотр;   
		НовыйЭлемент.Заголовок = Колонка.Заголовок;
		НовыйЭлемент.Подсказка = Колонка.Заголовок;
		НовыйЭлемент.ПутьКДанным = ИмяТаблицы+"."+Колонка.Имя;    
	КонецЦикла;
	
	
КонецПроцедуры         

&НаКлиенте
Процедура ДобавитьВКорзинуСтроку(ТекущиеДанные)
	
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	мОтбор = новый Структура("name,list,func",ТекущиеДанные.name,ТекущиеДанные.list,"");
	
	н_строки = Корзина.НайтиСтроки(мОтбор);
	
	Если н_строки.Количество()=0 Тогда
		стр_н = Корзина.Добавить();
		ЗаполнитьЗначенияСвойств(стр_н,ТекущиеДанные);
	Иначе
		Сообщить("Свойство "+ТекущиеДанные.name+" списка "+ТекущиеДанные.list+" и пустой функцией уже выбрано!");
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура УдалитьИзКорзины(Команда)
	
	Для каждого стр из Элементы.Корзина.ВыделенныеСтроки Цикл
		Корзина.Удалить(Корзина.НайтиПоИдентификатору(стр));
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти


&НаСервере
Функция ПолучитьСоответсвиеСинонимовСвойств()
	РеквизитОбъект = РеквизитФормыВЗначение("Объект");
	возврат РеквизитОбъект.ПолучитьСоответсвиеСинонимовСвойств()
КонецФункции

&НаСервере
Процедура ВыполнитьЗамерНаСервере()
	РеквизитОбъект = РеквизитФормыВЗначение("Объект");
	РеквизитОбъект.ЗагрузитьДанныеВЗамерСервер(Замер);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗамер(Команда)
	ВыполнитьЗамерНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьВСужденияСтроку(ТекущиеДанные)
	
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	Ключ = ТекущиеДанные.list+"->"+ТекущиеДанные.name+"("+ТекущиеДанные.func+")";
	мОтбор = новый Структура("key",Ключ);
	
	н_строки = ТаблицаСуждений.НайтиСтроки(мОтбор);
	
	Если н_строки.Количество()=0 Тогда
		стр_н = ТаблицаСуждений.Добавить();
		ЗаполнитьЗначенияСвойств(стр_н,ТекущиеДанные);
		ТекущиеДанные.key = Ключ;
		стр_н.key = Ключ;
	Иначе
		Сообщить("Свойство "+ТекущиеДанные.name+" списка "+ТекущиеДанные.list+" и пустой функцией уже выбрано!");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзСуждений(Команда) 
	Для каждого стр из Элементы.ТаблицаСуждений.ВыделенныеСтроки Цикл
		ТаблицаСуждений.Удалить(ТаблицаСуждений.НайтиПоИдентификатору(стр));
	КонецЦикла;	
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьВсеВСуждения(Команда)
	//TODO: Вставить содержимое обработчика
КонецПроцедуры

&НаКлиенте
Процедура Корзина1Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ДобавитьВСужденияСтроку(Элементы.Корзина1.ТекущиеДанные);
КонецПроцедуры




