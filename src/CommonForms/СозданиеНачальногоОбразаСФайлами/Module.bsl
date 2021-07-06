
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Менеджер = ПланыОбмена[Параметры.Узел.Метаданные().Имя];
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Если Параметры.Узел = Менеджер.ЭтотУзел() Тогда
		ВызватьИсключение
			НСтр("ru = 'Создание начального образа для данного узла невозможно.'");
	Иначе
		ВидБазы = 0; // файловая база
		ТипСУБД = "";
		Узел = Параметры.Узел;
		МожноСоздатьФайловуюБазу = Истина;
		Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
			МожноСоздатьФайловуюБазу = Ложь;
		КонецЕсли;
		
		КодыЛокализации = ПолучитьДопустимыеКодыЛокализации();
		ЯзыкФайловойБазы = Элементы.Найти("ЯзыкФайловойБазы");
		ЯзыкБазыСервера = Элементы.Найти("ЯзыкБазыСервера");
		
		Для Каждого Код Из КодыЛокализации Цикл
			Представление = ПредставлениеКодаЛокализации(Код);
			ЯзыкФайловойБазы.СписокВыбора.Добавить(Код, Представление);
			ЯзыкБазыСервера.СписокВыбора.Добавить(Код, Представление);
		КонецЦикла;
		
		Язык = КодЛокализацииИнформационнойБазы();
		
	КонецЕсли;
	
	ЕстьФайлыВТомах = Ложь;
	
	Если ФайловыеФункции.ЕстьТомаХраненияФайлов() Тогда
		ЕстьФайлыВТомах = ФайловыеФункцииСлужебный.ЕстьФайлыВТомах();
	КонецЕсли;
	
	ОССервераWindows = СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86
				   ИЛИ СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64;
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Элементы.ПолноеИмяФайловойБазыLinux.Видимость = НЕ ОССервераWindows;
		Элементы.ПолноеИмяФайловойБазы.Видимость = ОССервераWindows;
	КонецЕсли;
	
	Если ЕстьФайлыВТомах Тогда
		Если ОССервераWindows Тогда
			Элементы.ПолноеИмяФайловойБазы.АвтоОтметкаНезаполненного = Истина;
			Элементы.ПутьКАрхивуСФайламиТомов.АвтоОтметкаНезаполненного = Истина;
		Иначе
			Элементы.ПолноеИмяФайловойБазыLinux.АвтоОтметкаНезаполненного = Истина;
			Элементы.ПутьКАрхивуСФайламиТомовLinux.АвтоОтметкаНезаполненного = Истина;
		КонецЕсли;
	Иначе
		Элементы.ГруппаПутьКАрхивуСФайламиТомов.Видимость = Ложь;
	КонецЕсли;
	
	Если Не СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая Тогда
		Элементы.ПутьКАрхивуСФайламиТомов.ПодсказкаВвода = НСтр("ru = '\\имя сервера\resource\files.zip'");
		Элементы.ПутьКАрхивуСФайламиТомов.КнопкаВыбора = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ИсходныеДанные;
	Элементы.СоздатьНачальныйОбраз.Видимость = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидБазыПриИзменении(Элемент)
	
	// Переключить страницу параметров.
	Страницы = Элементы.Найти("Страницы");
	Страницы.ТекущаяСтраница = Страницы.ПодчиненныеЭлементы[ВидБазы];
	
	Если ЭтотОбъект.ВидБазы = 0 Тогда
		Элементы.ПутьКАрхивуСФайламиТомов.ПодсказкаВвода = "";
		Элементы.ПутьКАрхивуСФайламиТомов.КнопкаВыбора = Истина;
	Иначе
		Элементы.ПутьКАрхивуСФайламиТомов.ПодсказкаВвода = НСтр("ru = '\\имя сервера\resource\files.zip'");
		Элементы.ПутьКАрхивуСФайламиТомов.КнопкаВыбора = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКАрхивуСФайламиТомовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработчикСохраненияФайла(
		"ПутьКАрхивуСФайламиТомовWindows",
		СтандартнаяОбработка,
		"files.zip",
		"Архивы zip(*.zip)|*.zip");
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеИмяФайловойБазыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработчикСохраненияФайла(
		"ПолноеИмяФайловойБазыWindows",
		СтандартнаяОбработка,
		"1Cv8.1CD",
		"Любой файл(*.*)|*.*");
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеИмяФайловойБазыПриИзменении(Элемент)
	
	ПолноеИмяФайловойБазыWindows = СокрЛП(ПолноеИмяФайловойБазыWindows);
	СтруктураПути = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПолноеИмяФайловойБазыWindows);
	Если НЕ ПустаяСтрока(СтруктураПути.Путь) Тогда
		ПутьКФайлу = СтруктураПути.Путь;
		Если ПустаяСтрока(СтруктураПути.Расширение) Тогда
			ПутьКФайлу = СтруктураПути.ПолноеИмя;
			ПолноеИмяФайловойБазыWindows = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(СтруктураПути.ПолноеИмя);
			ПолноеИмяФайловойБазыWindows = ПолноеИмяФайловойБазыWindows + "1Cv8.1CD";
		КонецЕсли;
		МассивКаталогов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПутьКФайлу, "\", Истина);
		ПолныйПуть = "";
		Для Каждого Каталог Из МассивКаталогов Цикл
			ПолныйПуть = ПолныйПуть + Каталог + "\";
			Файл = Новый Файл(ПолныйПуть);
			Если НЕ Файл.Существует() Тогда
				НачатьСозданиеКаталога(Новый ОписаниеОповещения("ПолноеИмяФайловойБазыПриИзмененииЗавершение", ЭтотОбъект), ПолныйПуть);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеИмяФайловойБазыПриИзмененииЗавершение(ИмяКаталога, ДополнительныеПараметры) Экспорт
КонецПроцедуры // ПолноеИмяФайловойБазыПриИзмененииЗавершение

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьНачальныйОбраз(Команда)
	
	ОчиститьСообщения();
	Если ВидБазы = 0 И НЕ МожноСоздатьФайловуюБазу Тогда
		
		ВызватьИсключение
			НСтр("ru = 'Создание начального образа файловой информационной базы
			           |на данной платформе не поддерживается.'");
	Иначе
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Узел", Узел);
		ПараметрыЗадания.Вставить("ПутьКАрхивуСФайламиТомовWindows", ПутьКАрхивуСФайламиТомовWindows);
		ПараметрыЗадания.Вставить("ПутьКАрхивуСФайламиТомовLinux", ПутьКАрхивуСФайламиТомовLinux);
		
		Если ВидБазы = 0 Тогда
			// Файловый начальный образ.
			ПараметрыЗадания.Вставить("УникальныйИдентификаторФормы", УникальныйИдентификатор);
			ПараметрыЗадания.Вставить("Язык", Язык);
			ПараметрыЗадания.Вставить("ПолноеИмяФайловойБазыWindows", ПолноеИмяФайловойБазыWindows);
			ПараметрыЗадания.Вставить("ПолноеИмяФайловойБазыLinux", ПолноеИмяФайловойБазыLinux);
			ПараметрыЗадания.Вставить("НаименованиеЗадания", НСтр("ru = 'Создание файлового начального образа'"));
			ПараметрыЗадания.Вставить("НаименованиеПроцедуры", "ФайловыеФункцииСлужебный.СоздатьФайловыйНачальныйОбразНаСервере");
		Иначе
			// Серверный начальный образ.
			СтрокаСоединения =
				"Srvr="""       + Сервер + """;"
				+ "Ref="""      + ИмяБазы + """;"
				+ "DBMS="""     + ТипСУБД + """;"
				+ "DBSrvr="""   + СерверБазыДанных + """;"
				+ "DB="""       + ИмяБазыДанных + """;"
				+ "DBUID="""    + ПользовательБазыДанных + """;"
				+ "DBPwd="""    + ПарольПользователя + """;"
				+ "SQLYOffs=""" + Формат(СмещениеДат, "ЧГ=") + """;"
				+ "Locale="""   + Язык + """;"
				+ "SchJobDn=""" + ?(УстановитьБлокировкуРегламентныхЗаданий, "Y", "N") + """;";
			
			ПараметрыЗадания.Вставить("СтрокаСоединения", СтрокаСоединения);
			ПараметрыЗадания.Вставить("НаименованиеЗадания", НСтр("ru = 'Создание серверного начального образа'"));
			ПараметрыЗадания.Вставить("НаименованиеПроцедуры", "ФайловыеФункцииСлужебный.СоздатьСерверныйНачальныйОбразНаСервере");
		КонецЕсли;
		Результат = ПодготовитьДанныеДляСозданияНачальногоОбраза(ПараметрыЗадания, ВидБазы);
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			Если Результат.ДанныеПодготовлены Тогда
				АдресПараметровЗадания = ПоместитьВоВременноеХранилище(ПараметрыЗадания, УникальныйИдентификатор);
				ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьСозданиеНачальногоОбраза", ЭтотОбъект);
				Если Результат.ТребуетсяПодтверждение Тогда
					ПоказатьВопрос(ОписаниеОповещения, Результат.ТекстВопроса, РежимДиалогаВопрос.ДаНет);
				Иначе
					ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработчикСохраненияФайла(ИмяСвойства,
                                    СтандартнаяОбработка,
                                    ИмяФайла,
                                    Фильтр = "")
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяСвойства", ИмяСвойства);
	ДополнительныеПараметры.Вставить("ИмяФайла", ИмяФайла);
	ДополнительныеПараметры.Вставить("Фильтр", Фильтр);
	
	ОповещениеПодключенияРасширенияРаботыСФайлами = Новый ОписаниеОповещения(
		"ОбработчикСохраненияФайлаПослеПодключенияРасширенияРаботыСФайлами",
		ЭтотОбъект, ДополнительныеПараметры);
	
	НачатьПодключениеРасширенияРаботыСФайлами(ОповещениеПодключенияРасширенияРаботыСФайлами);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикСохраненияФайлаПослеПодключенияРасширенияРаботыСФайлами(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Не Подключено Тогда
		ФайловыеФункцииСлужебныйКлиент.ПоказатьПредупреждениеОНеобходимостиРасширенияРаботыСФайлами(Неопределено);
		Возврат;
	КонецЕсли;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	
	Диалог.Заголовок                = НСтр("ru = 'Выберите файл для сохранения'");
	Диалог.МножественныйВыбор       = Ложь;
	Диалог.ПредварительныйПросмотр  = Ложь;
	Диалог.Фильтр                   = ДополнительныеПараметры.Фильтр;
	Диалог.ПолноеИмяФайла           =
		?(ЭтотОбъект[ДополнительныеПараметры.ИмяСвойства] = "",
		ДополнительныеПараметры.ИмяФайла,
		ЭтотОбъект[ДополнительныеПараметры.ИмяСвойства]);
	
	ОписаниеОповещенияДиалогаВыбора = Новый ОписаниеОповещения(
		"ОбработчикСохраненияФайлаПослеВыбораВДиалоге",
		ЭтотОбъект, ДополнительныеПараметры);
	Диалог.Показать(ОписаниеОповещенияДиалогаВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикСохраненияФайлаПослеВыбораВДиалоге(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено
		И ВыбранныеФайлы.Количество() = 1 Тогда
		
		ЭтотОбъект[ДополнительныеПараметры.ИмяСвойства] = ВыбранныеФайлы[0];
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодготовитьДанныеДляСозданияНачальногоОбраза(ПараметрыЗадания, ВидБазы)
	
	Если ВидБазы = 0 Тогда
		// Файловый начальный образ.
		// Функция обработки, проверки и подготовки параметров.
		Результат = ФайловыеФункцииСлужебный.ПодготовитьДанныеДляСозданияФайловогоНачальногоОбраза(ПараметрыЗадания);
	Иначе
		// Серверный начальный образ.
		// Функция обработки, проверки и подготовки параметров.
		Результат = ФайловыеФункцииСлужебный.ПодготовитьДанныеДляСозданияСерверногоНачальногоОбраза(ПараметрыЗадания);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьСозданиеНачальногоОбраза(Результат, Неопределен) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПроцентВыполнения = 0;
		ДопИнформацияВыполнение = "";
		ПодключитьОбработчикОжидания("ЗапуститьСозданиеНачальногоОбраза", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьСозданиеНачальногоОбраза()
	
	Результат = СоздатьНачальныйОбразНаСервере(ВидБазы);
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполняется" Тогда
		ОповещениеОЗавершении = Новый ОписаниеОповещения("СоздатьНачальныйОбразНаСервереЗавершение", ЭтотОбъект);
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
		ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("СоздатьНачальныйОбразНаСервереПрогресс", ЭтотОбъект);;
		ДлительныеОперацииКлиент.ОжидатьЗавершение(Результат, ОповещениеОЗавершении, ПараметрыОжидания);
		ПерейтиКСтраницеОжидания();
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		ПерейтиКСтраницеОжидания();
		ПроцентВыполнения = 100;
		ДопИнформацияВыполнение = "";
		// Переход к странице с результатом с задержкой в 1 сек.
		ПодключитьОбработчикОжидания("ЗапуститьПереходРезультат", 1, Истина);
	Иначе
		ВызватьИсключение НСтр("ru = 'Не удалось создать начальный образ по причине:'") + " " + Результат.КраткоеПредставлениеОшибки; 
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСтраницеОжидания()
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ОжиданиеСозданияНачальногоОбраза;
	Элементы.СоздатьНачальныйОбраз.Видимость = Ложь;
КонецПроцедуры

&НаСервере
Функция СоздатьНачальныйОбразНаСервере(Знач Действие)
	
	Если ЭтоАдресВременногоХранилища(АдресПараметровЗадания) Тогда
		ПараметрыЗадания = ПолучитьИзВременногоХранилища(АдресПараметровЗадания);
		Если ТипЗнч(ПараметрыЗадания) = Тип("Структура") Тогда
			// Запуск фонового задания.
			ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
			ПараметрыВыполнения.НаименованиеФоновогоЗадания = ПараметрыЗадания.НаименованиеЗадания;
			
			Возврат ДлительныеОперации.ВыполнитьВФоне(ПараметрыЗадания.НаименованиеПроцедуры, ПараметрыЗадания, ПараметрыВыполнения);
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СоздатьНачальныйОбразНаСервереЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ПроцентВыполнения = 0;
		ДопИнформацияВыполнение = НСтр("ru = 'Действие отменено администратором.'");
		ЗапуститьПереходРезультат();
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ПроцентВыполнения = 0;
		Элементы.СтатусГотово.Заголовок = НСтр("ru = 'Не удалось создать начальный образ по причине:'") + " " + Результат.КраткоеПредставлениеОшибки;
		ЗапуститьПереходРезультат();
		Возврат;
	КонецЕсли;
	
	ПроцентВыполнения = 100;
	ДопИнформацияВыполнение = "";
	ЗапуститьПереходРезультат();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНачальныйОбразНаСервереПрогресс(Прогресс, ДополнительныеПараметры) Экспорт
	
	Если Прогресс = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Прогресс.Прогресс <> Неопределено Тогда
		СтруктураПрогресса = Прогресс.Прогресс;
		ПроцентВыполнения = СтруктураПрогресса.Процент;
		ДопИнформацияВыполнение = СтруктураПрогресса.Текст;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьПереходРезультат()
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.Результат;
	Элементы.СоздатьНачальныйОбраз.Видимость = Ложь;
КонецПроцедуры

#КонецОбласти
