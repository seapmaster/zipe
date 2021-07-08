#Область ОписаниеПеременных

&НаКлиенте
Перем НарастающийНомерИзображения;

&НаКлиенте
Перем ПозицияДляВставки;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ТаблицаФайлов.Видимость = Ложь;
	Элементы.ФормаПринятьВсеКакОдинФайл.Видимость = Ложь;
	Элементы.ФормаПринятьВсеКакОтдельныеФайлы.Видимость = Ложь;
	
	Если Параметры.Свойство("ВладелецФайла") Тогда
		ВладелецФайла = Параметры.ВладелецФайла;
	КонецЕсли;
	
	Если Параметры.Свойство("ЭтоФайл") Тогда
		ЭтоФайл = Параметры.ЭтоФайл;
	КонецЕсли;
	
	ИдентификаторКлиента = Параметры.ИдентификаторКлиента;
	
	Если Параметры.Свойство("НеОткрыватьКарточкуПослеСозданияИзФайла") Тогда
		НеОткрыватьКарточкуПослеСозданияИзФайла = Параметры.НеОткрыватьКарточкуПослеСозданияИзФайла;
	КонецЕсли;
	
	НомерФайла = ФайловыеФункцииСлужебныйВызовСервера.ПолучитьНовыйНомерДляСканирования(ВладелецФайла);
	ИмяФайла = ФайловыеФункцииСлужебныйКлиентСервер.ИмяСканированногоФайла(НомерФайла, "");

	ФорматСканированногоИзображения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ФорматСканированногоИзображения", 
		ИдентификаторКлиента, Перечисления.ФорматыСканированногоИзображения.PNG);
	
	ФорматХраненияОдностраничный = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ФорматХраненияОдностраничный", 
		ИдентификаторКлиента, Перечисления.ФорматыХраненияОдностраничныхФайлов.PNG);
	
	ФорматХраненияМногостраничный = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ФорматХраненияМногостраничный", 
		ИдентификаторКлиента, Перечисления.ФорматыХраненияМногостраничныхФайлов.TIF);
	
	РазрешениеПеречисление = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/Разрешение", 
		ИдентификаторКлиента);
	
	ЦветностьПеречисление = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/Цветность", 
		ИдентификаторКлиента);
	
	ПоворотПеречисление = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/Поворот", 
		ИдентификаторКлиента);
	
	РазмерБумагиПеречисление = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/РазмерБумаги", 
		ИдентификаторКлиента);
	
	ДвустороннееСканирование = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ДвустороннееСканирование", 
		ИдентификаторКлиента);
	
	ИспользоватьImageMagickДляПреобразованияВPDF = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ИспользоватьImageMagickДляПреобразованияВPDF", 
		ИдентификаторКлиента);
	
	КачествоJPG = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/КачествоJPG", 
		ИдентификаторКлиента, 100);
	
	СжатиеTIFF = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/СжатиеTIFF", 
		ИдентификаторКлиента, Перечисления.ВариантыСжатияTIFF.БезСжатия);
	
	ПутьКПрограммеКонвертации = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ПутьКПрограммеКонвертации", 
		ИдентификаторКлиента, "convert.exe"); // ImageMagick
	
	ПоказыватьДиалогСканераЗагрузка = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ПоказыватьДиалогСканера", 
		ИдентификаторКлиента, Истина);
	
	ПоказыватьДиалогСканера = ПоказыватьДиалогСканераЗагрузка;
	
	ИмяУстройства = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСканирования/ИмяУстройства", 
		ИдентификаторКлиента, "");
	
	ИмяУстройстваСканирования = ИмяУстройства;
	
	Если ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Если ФорматХраненияОдностраничный = Перечисления.ФорматыХраненияОдностраничныхФайлов.PDF Тогда
			ФорматКартинки = Строка(ФорматСканированногоИзображения);
		Иначе	
			ФорматКартинки = Строка(ФорматХраненияОдностраничный);
		КонецЕсли;
	Иначе	
		ФорматКартинки = Строка(ФорматСканированногоИзображения);
	КонецЕсли;
	
	ФорматJPG = Перечисления.ФорматыСканированногоИзображения.JPG;
	ФорматTIF = Перечисления.ФорматыСканированногоИзображения.TIF;
	
	ПреобразоватьПеречисленияВПараметрыИПолучитьПредставление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ПроверкиПриОткрытииВыполнены Тогда
		Отказ = Истина;
		ПодключитьОбработчикОжидания("ПередОткрытием", 0.1, Истина);
	КонецЕсли;
	
	ПозицияДляВставки = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Обработка.Сканирование.Форма.НастройкаСканированияНаСеанс") Тогда
		
		Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		
		РазрешениеПеречисление   = ВыбранноеЗначение.Разрешение;
		ЦветностьПеречисление    = ВыбранноеЗначение.Цветность;
		ПоворотПеречисление      = ВыбранноеЗначение.Поворот;
		РазмерБумагиПеречисление = ВыбранноеЗначение.РазмерБумаги;
		ДвустороннееСканирование = ВыбранноеЗначение.ДвустороннееСканирование;
		
		ИспользоватьImageMagickДляПреобразованияВPDF = ВыбранноеЗначение.ИспользоватьImageMagickДляПреобразованияВPDF;
		
		ПоказыватьДиалогСканера         = ВыбранноеЗначение.ПоказыватьДиалогСканера;
		ФорматСканированногоИзображения = ВыбранноеЗначение.ФорматСканированногоИзображения;
		КачествоJPG                     = ВыбранноеЗначение.КачествоJPG;
		СжатиеTIFF                      = ВыбранноеЗначение.СжатиеTIFF;
		ФорматХраненияОдностраничный    = ВыбранноеЗначение.ФорматХраненияОдностраничный;
		ФорматХраненияМногостраничный   = ВыбранноеЗначение.ФорматХраненияМногостраничный;
		
		ПреобразоватьПеречисленияВПараметрыИПолучитьПредставление();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	УдалитьВременныеФайлы(ТаблицаФайлов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаФайлов

&НаКлиенте
Процедура ТаблицаФайловПриАктивизацииСтроки(Элемент)
#Если НЕ ВебКлиент Тогда
	Если Элементы.ТаблицаФайлов.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	НомерТекущейСтроки = Элементы.ТаблицаФайлов.ТекущаяСтрока;
	СтрокаТаблицы = Элементы.ТаблицаФайлов.ДанныеСтроки(НомерТекущейСтроки);
	
	Если ПутьКВыбранномуФайлу <> СтрокаТаблицы.ПутьКФайлу Тогда
		
		ПутьКВыбранномуФайлу = СтрокаТаблицы.ПутьКФайлу;
		
		Если ПустаяСтрока(СтрокаТаблицы.АдресКартинки) Тогда
			ДвоичныеДанные = Новый ДвоичныеДанные(ПутьКВыбранномуФайлу);
			СтрокаТаблицы.АдресКартинки = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		КонецЕсли;
		
		АдресКартинки = СтрокаТаблицы.АдресКартинки;
		
	КонецЕсли;
	
#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловПередУдалением(Элемент, Отказ)
	
	Если ТаблицаФайлов.Количество() < 2 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	НомерТекущейСтроки = Элементы.ТаблицаФайлов.ТекущаяСтрока;
	СтрокаТаблицы = Элементы.ТаблицаФайлов.ДанныеСтроки(НомерТекущейСтроки);
	НачатьУдалениеФайлов(Новый ОписаниеОповещения("ТаблицаФайловПередУдалениемЗавершение", ЭтотОбъект), СтрокаТаблицы.ПутьКФайлу);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловПередУдалениемЗавершение(ДополнительныеПараметры) Экспорт
	Если ТаблицаФайлов.Количество() = 2 Тогда
		Элементы.ТаблицаФайловКонтекстноеМенюУдалить.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Кнопка "Пересканировать" замещает выделенную (или единственную, если она одна) картинку 
//  (или добавляет в конец новые картинки, если ничего не выделено) новым изображением (изображениями).
&НаКлиенте
Процедура Пересканировать(Команда)
	
	Если ТаблицаФайлов.Количество() = 1 Тогда
		УдалитьВременныеФайлы(ТаблицаФайлов);
		ПозицияДляВставки = 0;
	ИначеЕсли ТаблицаФайлов.Количество() > 1 Тогда
		
		НомерТекущейСтроки = Элементы.ТаблицаФайлов.ТекущаяСтрока;
		СтрокаТаблицы = Элементы.ТаблицаФайлов.ДанныеСтроки(НомерТекущейСтроки);
		ПозицияДляВставки = ТаблицаФайлов.Индекс(СтрокаТаблицы);
		НачатьУдалениеФайлов(Новый ОписаниеОповещения("ПересканироватьЗавершение", ЭтотОбъект, Новый Структура("СтрокаТаблицы", СтрокаТаблицы)), СтрокаТаблицы.ПутьКФайлу);
        Возврат;
		
	КонецЕсли;
	
	ПересканироватьФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ПересканироватьЗавершение(ДополнительныеПараметры) Экспорт
	СтрокаТаблицы = ДополнительныеПараметры.СтрокаТаблицы;
	ТаблицаФайлов.Удалить(СтрокаТаблицы);
	ПересканироватьФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ПересканироватьФрагмент()
	
	Перем ВыбранноеУстройство, ПараметрСжатие, ПоказыватьДиалог;
	
	Если АдресКартинки <> "" Тогда
		УдалитьИзВременногоХранилища(АдресКартинки);
	КонецЕсли;	
	АдресКартинки = "";
	ПутьКВыбранномуФайлу = "";
	
	ПоказыватьДиалог = ПоказыватьДиалогСканера;
	ВыбранноеУстройство = ИмяУстройстваСканирования;
	ПараметрСжатие = ?(ВРег(ФорматКартинки) = "JPG", КачествоJPG, СжатиеTIFFЧисло);
	
	ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].НачатьСканирование(
	ПоказыватьДиалог, ВыбранноеУстройство, ФорматКартинки, 
	Разрешение, Цветность, Поворот, РазмерБумаги, 
	ПараметрСжатие,
	ДвустороннееСканирование);

КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("МассивФайловКопия", Новый Массив);
	ПараметрыВыполнения.Вставить("ФайлРезультата", "");
	ПараметрыВыполнения.Вставить("ОписаниеОповещенияОЗакрытии", Неопределено);
	
	Для Каждого Строка Из ТаблицаФайлов Цикл
		//АВ+
		ПараметрыВыполнения.МассивФайловКопия.Добавить(Новый Структура("ПутьКФайлу", Строка.ПутьКФайлу));
	КонецЦикла;
	
	// Здесь работаем с одним файлом.
	СтрокаТаблицы = ТаблицаФайлов.Получить(0);
	ПутьКФайлуЛокальный = СтрокаТаблицы.ПутьКФайлу;
	
	ТаблицаФайлов.Очистить(); // Чтобы не удалились файлы в ПриЗакрытии.
	
	Если ТипЗнч(ОписаниеОповещенияОЗакрытии) = Тип("ОписаниеОповещения") Тогда
		ПараметрыВыполнения.Вставить("ОписаниеОповещенияОЗакрытии", ОписаниеОповещенияОЗакрытии);
		ОписаниеОповещенияОЗакрытии = Неопределено;
	КонецЕсли;
	
	Закрыть();
	
	РасширениеРезультата = Строка(ФорматХраненияОдностраничный);
	РасширениеРезультата = НРег(РасширениеРезультата); 
	
	Если РасширениеРезультата = "pdf" Тогда
		
		#Если НЕ ВебКлиент Тогда
			ПараметрыВыполнения.ФайлРезультата = ПолучитьИмяВременногоФайла("pdf");
		#КонецЕсли
		
		СтрокаВсехПутей = ПутьКФайлуЛокальный;
		ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].ОбъединитьВМногостраничныйФайл(
			СтрокаВсехПутей, ПараметрыВыполнения.ФайлРезультата, ПутьКПрограммеКонвертации);
		
		ОбъектФайлРезультата = Новый Файл(ПараметрыВыполнения.ФайлРезультата);
		ОбъектФайлРезультата.НачатьПроверкуСуществования(Новый ОписаниеОповещения("СохранитьЗавершение", ЭтотОбъект, Новый Структура("ПараметрыВыполнения, ПутьКФайлуЛокальный", ПараметрыВыполнения, ПутьКФайлуЛокальный)));
        Возврат;
		
	КонецЕсли;
	
	СохранитьФрагмент(ПараметрыВыполнения, ПутьКФайлуЛокальный);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗавершение(Существует, ДополнительныеПараметры) Экспорт
	
	ПараметрыВыполнения = ДополнительныеПараметры.ПараметрыВыполнения;
	ПутьКФайлуЛокальный = ДополнительныеПараметры.ПутьКФайлуЛокальный;
	
	Если НЕ Существует Тогда
		ТекстСообщения = ТекстСообщенияОшибкиПреобразованияВPDF(ПараметрыВыполнения.ФайлРезультата);
		ПоказатьПредупреждение(, ТекстСообщения);
		НачатьУдалениеФайлов(Новый ОписаниеОповещения("СохранитьЗавершениеЗавершение1", ЭтотОбъект, Новый Структура("ПараметрыВыполнения", ПараметрыВыполнения)), ПутьКФайлуЛокальный);
		Возврат;
	КонецЕсли;
	
	НачатьУдалениеФайлов(Новый ОписаниеОповещения("СохранитьЗавершениеЗавершение", ЭтотОбъект, Новый Структура("ПараметрыВыполнения, ПутьКФайлуЛокальный", ПараметрыВыполнения, ПутьКФайлуЛокальный)), ПутьКФайлуЛокальный);

КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗавершениеЗавершение1(ДополнительныеПараметры1) Экспорт
	ПараметрыВыполнения = ДополнительныеПараметры1.ПараметрыВыполнения;
	ПринятьЗавершение(-1, ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗавершениеЗавершение(ДополнительныеПараметры1) Экспорт
	
	ПараметрыВыполнения = ДополнительныеПараметры1.ПараметрыВыполнения;
	ПутьКФайлуЛокальный = ДополнительныеПараметры1.ПутьКФайлуЛокальный;
	
	ПутьКФайлуЛокальный = ПараметрыВыполнения.ФайлРезультата;
	
	СохранитьФрагмент(ПараметрыВыполнения, ПутьКФайлуЛокальный);

КонецПроцедуры

&НаКлиенте
Процедура СохранитьФрагмент(Знач ПараметрыВыполнения, Знач ПутьКФайлуЛокальный)
	
	Перем Обработчик, ПараметрыДобавления;
	
	Если НЕ ПустаяСтрока(ПутьКФайлуЛокальный) Тогда
		Обработчик = Новый ОписаниеОповещения("ПринятьЗавершение", ЭтотОбъект, ПараметрыВыполнения);
		
		ПараметрыДобавления = Новый Структура;
		ПараметрыДобавления.Вставить("ОбработчикРезультата", Обработчик);
		ПараметрыДобавления.Вставить("ПолноеИмяФайла", ПутьКФайлуЛокальный);
		ПараметрыДобавления.Вставить("ВладелецФайла", ВладелецФайла);
		ПараметрыДобавления.Вставить("ФормаВладелец", ЭтотОбъект);
		ПараметрыДобавления.Вставить("ИмяСоздаваемогоФайла", ИмяФайла);
		ПараметрыДобавления.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", НеОткрыватьКарточкуПослеСозданияИзФайла);
		ПараметрыДобавления.Вставить("ИдентификаторФормы", УникальныйИдентификатор);
		ПараметрыДобавления.Вставить("ЭтоФайл", ЭтоФайл);
		
		ФайловыеФункцииСлужебныйКлиент.ДобавитьИзФайловойСистемыСРасширением(ПараметрыДобавления);
		
		Возврат;
	КонецЕсли;
	
	ПринятьЗавершение(-1, ПараметрыВыполнения);

КонецПроцедуры

&НаКлиенте
Процедура Настройка(Команда)
	
	ДвустороннееСканированиеЧисло = ФайловыеФункцииСлужебныйКлиент.ПолучитьНастройку(
		ИмяУстройстваСканирования, "DUPLEX");
	
	ДоступностьДвустороннееСканирование = (ДвустороннееСканированиеЧисло <> -1);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказыватьДиалогСканера",  ПоказыватьДиалогСканера);
	ПараметрыФормы.Вставить("Разрешение",               РазрешениеПеречисление);
	ПараметрыФормы.Вставить("Цветность",                ЦветностьПеречисление);
	ПараметрыФормы.Вставить("Поворот",                  ПоворотПеречисление);
	ПараметрыФормы.Вставить("РазмерБумаги",             РазмерБумагиПеречисление);
	ПараметрыФормы.Вставить("ДвустороннееСканирование", ДвустороннееСканирование);
	
	ПараметрыФормы.Вставить(
		"ИспользоватьImageMagickДляПреобразованияВPDF", ИспользоватьImageMagickДляПреобразованияВPDF);
	
	ПараметрыФормы.Вставить("ДоступностьПоворот",       ДоступностьПоворот);
	ПараметрыФормы.Вставить("ДоступностьРазмерБумаги",  ДоступностьРазмерБумаги);
	
	ПараметрыФормы.Вставить("ДоступностьДвустороннееСканирование", ДоступностьДвустороннееСканирование);
	ПараметрыФормы.Вставить("ФорматСканированногоИзображения",     ФорматСканированногоИзображения);
	ПараметрыФормы.Вставить("КачествоJPG",                         КачествоJPG);
	ПараметрыФормы.Вставить("СжатиеTIFF",                          СжатиеTIFF);
	ПараметрыФормы.Вставить("ФорматХраненияОдностраничный",        ФорматХраненияОдностраничный);
	ПараметрыФормы.Вставить("ФорматХраненияМногостраничный",       ФорматХраненияМногостраничный);
	
	ОткрытьФорму("Обработка.Сканирование.Форма.НастройкаСканированияНаСеанс", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВсеКакОдинФайл(Команда)
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("МассивФайловКопия", Новый Массив);
	ПараметрыВыполнения.Вставить("ФайлРезультата", "");
	ПараметрыВыполнения.Вставить("ОписаниеОповещенияОЗакрытии", Неопределено);
	
	Для Каждого Строка Из ТаблицаФайлов Цикл
		//АВ+
		ПараметрыВыполнения.МассивФайловКопия.Добавить(Новый Структура("ПутьКФайлу", Строка.ПутьКФайлу));
	КонецЦикла;
	
	ТаблицаФайлов.Очистить(); // Чтобы не удалились файлы в ПриЗакрытии.
	
	Если ТипЗнч(ОписаниеОповещенияОЗакрытии) = Тип("ОписаниеОповещения") Тогда
		ПараметрыВыполнения.Вставить("ОписаниеОповещенияОЗакрытии", ОписаниеОповещенияОЗакрытии);
		ОписаниеОповещенияОЗакрытии = Неопределено;
	КонецЕсли;
	
	Закрыть();
	
	// Здесь работаем со всеми картинками - объединяем их в один многостраничный файл.
	СтрокаВсехПутей = "";
	Для Каждого Строка Из ПараметрыВыполнения.МассивФайловКопия Цикл
		СтрокаВсехПутей = СтрокаВсехПутей + "*";
		СтрокаВсехПутей = СтрокаВсехПутей + Строка.ПутьКФайлу;
	КонецЦикла;
	
	#Если НЕ ВебКлиент Тогда
		РасширениеРезультата = Строка(ФорматХраненияМногостраничный);
		РасширениеРезультата = НРег(РасширениеРезультата); 
		ПараметрыВыполнения.ФайлРезультата = ПолучитьИмяВременногоФайла(РасширениеРезультата);
	#КонецЕсли
	ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].ОбъединитьВМногостраничныйФайл(
		СтрокаВсехПутей, ПараметрыВыполнения.ФайлРезультата, ПутьКПрограммеКонвертации);
	
	ОбъектФайлРезультата = Новый Файл(ПараметрыВыполнения.ФайлРезультата);
	ОбъектФайлРезультата.НачатьПроверкуСуществования(Новый ОписаниеОповещения("СохранитьВсеКакОдинФайлЗавершение", ЭтотОбъект, Новый Структура("ПараметрыВыполнения", ПараметрыВыполнения)));
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВсеКакОдинФайлЗавершение(Существует, ДополнительныеПараметры) Экспорт
	
	ПараметрыВыполнения = ДополнительныеПараметры.ПараметрыВыполнения;
	
	Если НЕ Существует Тогда
		ТекстСообщения = ТекстСообщенияОшибкиПреобразованияВPDF(ПараметрыВыполнения.ФайлРезультата);
		ПараметрыВыполнения.ФайлРезультата = "";
		Обработчик = Новый ОписаниеОповещения("ПринятьВсеКакОдинФайлЗавершение", ЭтотОбъект, ПараметрыВыполнения);
		ПоказатьПредупреждение(Обработчик, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ПараметрыВыполнения.ФайлРезультата) Тогда
		Обработчик = Новый ОписаниеОповещения("ПринятьВсеКакОдинФайлЗавершение", ЭтотОбъект, ПараметрыВыполнения);
		
		ПараметрыДобавления = Новый Структура;
		ПараметрыДобавления.Вставить("ОбработчикРезультата", Обработчик);
		ПараметрыДобавления.Вставить("ВладелецФайла", ВладелецФайла);
		ПараметрыДобавления.Вставить("ФормаВладелец", ЭтотОбъект);
		ПараметрыДобавления.Вставить("ПолноеИмяФайла", ПараметрыВыполнения.ФайлРезультата);
		ПараметрыДобавления.Вставить("ИмяСоздаваемогоФайла", ИмяФайла);
		ПараметрыДобавления.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", НеОткрыватьКарточкуПослеСозданияИзФайла);
		ПараметрыДобавления.Вставить("ИдентификаторФормы", УникальныйИдентификатор);
		ПараметрыДобавления.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
		ПараметрыДобавления.Вставить("ЭтоФайл", ЭтоФайл);
		
		ФайловыеФункцииСлужебныйКлиент.ДобавитьИзФайловойСистемыСРасширением(ПараметрыДобавления);
		
		Возврат;
	КонецЕсли;
	
	ПринятьВсеКакОдинФайлЗавершение(-1, ПараметрыВыполнения);

КонецПроцедуры

&НаКлиенте
Асинх Процедура СохранитьВсеКакОтдельныеФайлы(Команда)
	
	МассивФайловКопия = Новый Массив;
	Для Каждого Строка Из ТаблицаФайлов Цикл
		МассивФайловКопия.Добавить(Новый Структура("ПутьКФайлу", Строка.ПутьКФайлу));
	КонецЦикла;
	
	ТаблицаФайлов.Очистить(); // Чтобы не удалились файлы в ПриЗакрытии.
	
	ОписаниеОповещенияОРезультатахСканирования = Неопределено;
	Если ТипЗнч(ОписаниеОповещенияОЗакрытии) = Тип("ОписаниеОповещения") Тогда
		ОписаниеОповещенияОРезультатахСканирования = ОписаниеОповещенияОЗакрытии;
		ОписаниеОповещенияОЗакрытии = Неопределено;
	КонецЕсли;
	
	Закрыть();
	
	РасширениеРезультата = Строка(ФорматХраненияОдностраничный);
	РасширениеРезультата = НРег(РасширениеРезультата); 
	
	ПараметрыДобавления = Новый Структура;
	ПараметрыДобавления.Вставить("ВладелецФайла", ВладелецФайла);
	ПараметрыДобавления.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыДобавления.Вставить("ИдентификаторФормы", УникальныйИдентификатор);
	ПараметрыДобавления.Вставить("ФормаВладелец", ЭтотОбъект);
	ПараметрыДобавления.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", Истина);
	ПараметрыДобавления.Вставить("ПолноеИмяФайла", "");
	ПараметрыДобавления.Вставить("ИмяСоздаваемогоФайла", "");
	ПараметрыДобавления.Вставить("ЭтоФайл", ЭтоФайл);
	
	ПолныйТекстВсехОшибок = "";
	КоличествоОшибок = 0;
	
	// Здесь работаем со всеми картинками -каждую как отдельный файл принимаем.
	Для Каждого Строка Из МассивФайловКопия Цикл
		
		ПутьКФайлуЛокальный = Строка.ПутьКФайлу;
		
		ФайлРезультата = "";
		Если РасширениеРезультата = "pdf" Тогда
			
			#Если НЕ ВебКлиент Тогда
				ФайлРезультата = ПолучитьИмяВременногоФайла("pdf");
			#КонецЕсли
			
			СтрокаВсехПутей = ПутьКФайлуЛокальный;
			ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].ОбъединитьВМногостраничныйФайл(
				СтрокаВсехПутей, ФайлРезультата, ПутьКПрограммеКонвертации);
			
			ОбъектФайлРезультата = Новый Файл(ФайлРезультата);
			РезультатСуществует  = Ждать ОбъектФайлРезультата.СуществуетАсинх();
			
			Если НЕ РезультатСуществует Тогда
				ТекстОшибки = ТекстСообщенияОшибкиПреобразованияВPDF(ФайлРезультата);
				Если ПолныйТекстВсехОшибок <> "" Тогда
					ПолныйТекстВсехОшибок = ПолныйТекстВсехОшибок + Символы.ПС + Символы.ПС + "---" + Символы.ПС + Символы.ПС;
				КонецЕсли;
				ПолныйТекстВсехОшибок = ПолныйТекстВсехОшибок + ТекстОшибки;
				КоличествоОшибок = КоличествоОшибок + 1;
				ФайлРезультата = "";
			КонецЕсли;
			
			
			ПутьКФайлуЛокальный = ФайлРезультата;
			
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(ПутьКФайлуЛокальный) Тогда
			ПараметрыДобавления.ПолноеИмяФайла = ПутьКФайлуЛокальный;
			ПараметрыДобавления.ИмяСоздаваемогоФайла = ИмяФайла;
			Результат = ФайловыеФункцииСлужебныйКлиент.ДобавитьИзФайловойСистемыСРасширениемСинхронно(ПараметрыДобавления);
			Если ТипЗнч(ОписаниеОповещенияОРезультатахСканирования) = Тип("ОписаниеОповещения") Тогда
				ВыполнитьОбработкуОповещения(ОписаниеОповещенияОРезультатахСканирования, Результат);
			КонецЕсли;
			Если Не Результат.ФайлДобавлен Тогда
				Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
					ПоказатьПредупреждение(, Результат.ТекстОшибки);
					Возврат;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(ФайлРезультата) Тогда
			УдалитьФайлыАсинх(ФайлРезультата);
		КонецЕсли;
		
		НомерФайла = НомерФайла + 1;
		ИмяФайла = ФайловыеФункцииСлужебныйКлиентСервер.ИмяСканированногоФайла(НомерФайла, "");
		
	КонецЦикла;
	
	ФайловыеФункцииСлужебныйВызовСервера.ЗанестиМаксимальныйНомерДляСканирования(
		ВладелецФайла, НомерФайла - 1);
	
	УдалитьВременныеФайлы(МассивФайловКопия);
	
	Если КоличествоОшибок > 0 Тогда
		ПараметрыПредупреждения = Новый Структура("Текст, Подробно");
		Если КоличествоОшибок = 1 Тогда
			ПараметрыПредупреждения.Текст = ПолныйТекстВсехОшибок;
		Иначе
			ПараметрыПредупреждения.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'При выполнении возникли ошибки (%1).'"),
				Строка(КоличествоОшибок));
			ПараметрыПредупреждения.Подробно = ПолныйТекстВсехОшибок;
		КонецЕсли;
		СтандартныеПодсистемыКлиент.ВывестиПредупреждение(ЭтотОбъект, ПараметрыПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Сканировать(Команда)
	
	ПоказыватьДиалог = ПоказыватьДиалогСканера;
	ВыбранноеУстройство = ИмяУстройстваСканирования;
	ПутьКПрограммеКонвертации = "convert.exe";
	ПараметрСжатие = ?(ВРег(ФорматКартинки) = "JPG", КачествоJPG, СжатиеTIFFЧисло);
	
	ПозицияДляВставки = Неопределено;
	
	ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].НачатьСканирование(
		ПоказыватьДиалог, ВыбранноеУстройство, ФорматКартинки, 
		Разрешение, Цветность, Поворот, РазмерБумаги, 
		ПараметрСжатие,
		ДвустороннееСканирование);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередОткрытием()
	// Первичная инициализация автомата (вызов из ПриОткрытии()).
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ТекущийШаг", 1);
	ПараметрыОткрытия.Вставить("ПоказыватьДиалог", Неопределено);
	ПараметрыОткрытия.Вставить("ВыбранноеУстройство", Неопределено);
	ПередОткрытиемАвтомат(Неопределено, ПараметрыОткрытия);
КонецПроцедуры

&НаКлиенте
Асинх Процедура ПередОткрытиемАвтомат(Результат, ПараметрыОткрытия) Экспорт
	// Вторичная инициализация автомата (вызов из диалога, открытого автоматом).
	Если ПараметрыОткрытия.ТекущийШаг = 2 Тогда
		Если ТипЗнч(Результат) = Тип("Строка") И Не ПустаяСтрока(Результат) Тогда
			ПараметрыОткрытия.ВыбранноеУстройство = Результат;
			ИмяУстройстваСканирования = ПараметрыОткрытия.ВыбранноеУстройство;
		КонецЕсли;
		ПараметрыОткрытия.ТекущийШаг = 3;
	КонецЕсли;
	
	Если ПараметрыОткрытия.ТекущийШаг = 1 Тогда
		Если Не Ждать ФайловыеФункцииСлужебныйКлиент.ПроинициализироватьКомпоненту() Тогда
			Возврат;
		КонецЕсли;
		
		// Вызывается здесь, т.к. вызов ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].ЕстьУстройства()
		// занимает очень много времени (больше, чем ОбновитьПовторноИспользуемыеЗначения()).
		Если Не Ждать ФайловыеФункцииСлужебныйКлиент.ДоступнаКомандаСканировать() Тогда
			ОбновитьПовторноИспользуемыеЗначения();
			Возврат;
		КонецЕсли;
		
		ПараметрыОткрытия.ТекущийШаг = 2;
	КонецЕсли;
	
	Если ПараметрыОткрытия.ТекущийШаг = 2 Тогда
		ПараметрыОткрытия.ПоказыватьДиалог = ПоказыватьДиалогСканера;
		ПараметрыОткрытия.ВыбранноеУстройство = ИмяУстройстваСканирования;
		
		Если ПараметрыОткрытия.ВыбранноеУстройство = "" Тогда
			Обработчик = Новый ОписаниеОповещения("ПередОткрытиемАвтомат", ЭтотОбъект, ПараметрыОткрытия);
			ОткрытьФорму("Обработка.Сканирование.Форма.ВыборУстройстваСканирования", , ЭтотОбъект, , , , Обработчик, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
			Возврат;
		КонецЕсли;
		
		ПараметрыОткрытия.ТекущийШаг = 3;
	КонецЕсли;
	
	Если ПараметрыОткрытия.ТекущийШаг = 3 Тогда
		Если ПараметрыОткрытия.ВыбранноеУстройство = "" Тогда 
			Возврат; // Не открывать форму.
		КонецЕсли;
		
		Если Разрешение = -1 ИЛИ Цветность = -1 ИЛИ Поворот = -1 ИЛИ РазмерБумаги = -1 Тогда
			
			Разрешение = ФайловыеФункцииСлужебныйКлиент.ПолучитьНастройку(
				ПараметрыОткрытия.ВыбранноеУстройство,
				"XRESOLUTION");
			
			Цветность = ФайловыеФункцииСлужебныйКлиент.ПолучитьНастройку(
				ПараметрыОткрытия.ВыбранноеУстройство,
				"PIXELTYPE");
			
			Поворот = ФайловыеФункцииСлужебныйКлиент.ПолучитьНастройку(
				ПараметрыОткрытия.ВыбранноеУстройство,
				"ROTATION");
			
			РазмерБумаги = ФайловыеФункцииСлужебныйКлиент.ПолучитьНастройку(
				ПараметрыОткрытия.ВыбранноеУстройство,
				"SUPPORTEDSIZES");
			
			ДвустороннееСканированиеЧисло = ФайловыеФункцииСлужебныйКлиент.ПолучитьНастройку(
				ПараметрыОткрытия.ВыбранноеУстройство,
				"DUPLEX");
			
			ДоступностьПоворот = (Поворот <> -1);
			ДоступностьРазмерБумаги = (РазмерБумаги <> -1);
			ДоступностьДвустороннееСканирование = (ДвустороннееСканированиеЧисло <> -1);
			
			СистемнаяИнформация = Новый СистемнаяИнформация();
			ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
			
			СохранитьПараметрыСканера(Разрешение, Цветность, ИдентификаторКлиента);
		Иначе
			
			ДоступностьПоворот = Не ПоворотПеречисление.Пустая();
			ДоступностьРазмерБумаги = Не РазмерБумагиПеречисление.Пустая();
			ДоступностьДвустороннееСканирование = Истина;
			
		КонецЕсли;
		
		ИмяФайлаКартинки = "";
		Элементы.Сохранить.Доступность = Ложь;
		
		ПараметрСжатие = ?(ВРег(ФорматКартинки) = "JPG", КачествоJPG, СжатиеTIFFЧисло);
		
		Если Не Открыта() Тогда
			ПроверкиПриОткрытииВыполнены = Истина;
			Открыть();
			ПроверкиПриОткрытииВыполнены = Ложь;
		КонецЕсли;
		
		ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].НачатьСканирование(
			ПараметрыОткрытия.ПоказыватьДиалог,
			ПараметрыОткрытия.ВыбранноеУстройство,
			ФорматКартинки,
			Разрешение,
			Цветность,
			Поворот,
			РазмерБумаги,
			ПараметрСжатие,
			ДвустороннееСканирование);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УдалитьВременныеФайлы(ПараметрыВыполнения.МассивФайловКопия);
	Если НЕ ПустаяСтрока(ПараметрыВыполнения.ФайлРезультата) Тогда
		НачатьУдалениеФайлов(Новый ОписаниеОповещения("ПринятьЗавершениеЗавершение", ЭтотОбъект, Новый Структура("ПараметрыВыполнения, Результат", ПараметрыВыполнения, Результат)), ПараметрыВыполнения.ФайлРезультата);
        Возврат;
	КонецЕсли;
	ПринятьЗавершениеФрагмент(ПараметрыВыполнения, Результат);
КонецПроцедуры

&НаКлиенте
Процедура ПринятьЗавершениеЗавершение(ДополнительныеПараметры) Экспорт
	ПараметрыВыполнения = ДополнительныеПараметры.ПараметрыВыполнения;
	Результат = ДополнительныеПараметры.Результат;
	ПринятьЗавершениеФрагмент(ПараметрыВыполнения, Результат);
КонецПроцедуры

&НаКлиенте
Процедура ПринятьЗавершениеФрагмент(Знач ПараметрыВыполнения, Знач Результат)
	
	Если ТипЗнч(ПараметрыВыполнения.ОписаниеОповещенияОЗакрытии) = Тип("ОписаниеОповещения") Тогда
		ВыполнитьОбработкуОповещения(ПараметрыВыполнения.ОписаниеОповещенияОЗакрытии, Результат);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПринятьВсеКакОдинФайлЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УдалитьВременныеФайлы(ПараметрыВыполнения.МассивФайловКопия);
	НачатьУдалениеФайлов(Новый ОписаниеОповещения("ПринятьВсеКакОдинФайлЗавершениеЗавершение", ЭтотОбъект, Новый Структура("ПараметрыВыполнения, Результат", ПараметрыВыполнения, Результат)), ПараметрыВыполнения.ФайлРезультата);
КонецПроцедуры

&НаКлиенте
Процедура ПринятьВсеКакОдинФайлЗавершениеЗавершение(ДополнительныеПараметры) Экспорт
	
	ПараметрыВыполнения = ДополнительныеПараметры.ПараметрыВыполнения;
	Результат = ДополнительныеПараметры.Результат;
	
	Если ТипЗнч(ПараметрыВыполнения.ОписаниеОповещенияОЗакрытии) = Тип("ОписаниеОповещения") Тогда
		ВыполнитьОбработкуОповещения(ПараметрыВыполнения.ОписаниеОповещенияОЗакрытии, Результат);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПреобразоватьПеречисленияВПараметрыИПолучитьПредставление()
		
	Разрешение = -1;
	Если РазрешениеПеречисление = Перечисления.РазрешенияСканированногоИзображения.dpi200 Тогда
		Разрешение = 200; 
	ИначеЕсли РазрешениеПеречисление = Перечисления.РазрешенияСканированногоИзображения.dpi300 Тогда
		Разрешение = 300;
	ИначеЕсли РазрешениеПеречисление = Перечисления.РазрешенияСканированногоИзображения.dpi600 Тогда
		Разрешение = 600;
	ИначеЕсли РазрешениеПеречисление = Перечисления.РазрешенияСканированногоИзображения.dpi1200 Тогда
		Разрешение = 1200;
	КонецЕсли;
	
	Цветность = -1;
	Если ЦветностьПеречисление = Перечисления.ЦветностиИзображения.Монохромное Тогда
		Цветность = 0;
	ИначеЕсли ЦветностьПеречисление = Перечисления.ЦветностиИзображения.ГрадацииСерого Тогда
		Цветность = 1;
	ИначеЕсли ЦветностьПеречисление = Перечисления.ЦветностиИзображения.Цветное Тогда
		Цветность = 2;
	КонецЕсли;
	
	Поворот = 0;
	Если ПоворотПеречисление = Перечисления.СпособыПоворотаИзображения.НетПоворота Тогда
		Поворот = 0;
	ИначеЕсли ПоворотПеречисление = Перечисления.СпособыПоворотаИзображения.ВправоНа90 Тогда
		Поворот = 90;
	ИначеЕсли ПоворотПеречисление = Перечисления.СпособыПоворотаИзображения.ВправоНа180 Тогда
		Поворот = 180;
	ИначеЕсли ПоворотПеречисление = Перечисления.СпособыПоворотаИзображения.ВлевоНа90 Тогда
		Поворот = 270;
	КонецЕсли;
	
	РазмерБумаги = 0;
	Если РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.НеЗадано Тогда
		РазмерБумаги = 0;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.A3 Тогда
		РазмерБумаги = 11;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.A4 Тогда
		РазмерБумаги = 1;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.A5 Тогда
		РазмерБумаги = 5;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.B4 Тогда
		РазмерБумаги = 6;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.B5 Тогда
		РазмерБумаги = 2;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.B6 Тогда
		РазмерБумаги = 7;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.C4 Тогда
		РазмерБумаги = 14;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.C5 Тогда
		РазмерБумаги = 15;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.C6 Тогда
		РазмерБумаги = 16;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.USLetter Тогда
		РазмерБумаги = 3;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.USLegal Тогда
		РазмерБумаги = 4;
	ИначеЕсли РазмерБумагиПеречисление = Перечисления.РазмерыБумаги.USExecutive Тогда
		РазмерБумаги = 10;
	КонецЕсли;
	
	СжатиеTIFFЧисло = 6; // БезСжатия
	Если СжатиеTIFF = Перечисления.ВариантыСжатияTIFF.LZW Тогда
		СжатиеTIFFЧисло = 2;
	ИначеЕсли СжатиеTIFF = Перечисления.ВариантыСжатияTIFF.RLE Тогда
		СжатиеTIFFЧисло = 5;
	ИначеЕсли СжатиеTIFF = Перечисления.ВариантыСжатияTIFF.БезСжатия Тогда
		СжатиеTIFFЧисло = 6;
	ИначеЕсли СжатиеTIFF = Перечисления.ВариантыСжатияTIFF.CCITT3 Тогда
		СжатиеTIFFЧисло = 3;
	ИначеЕсли СжатиеTIFF = Перечисления.ВариантыСжатияTIFF.CCITT4 Тогда
		СжатиеTIFFЧисло = 4;
		
	КонецЕсли;
	
	Представление = "";
	// Информационная надпись вида:
	// "Формат хранения: PDF. Формат сканирования: JPG. Качество: 75. Формат хранения многостраничный: PDF. Разрешение:
	// 200. Цветное";
	
	Если ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Если ФорматХраненияОдностраничный = Перечисления.ФорматыХраненияОдностраничныхФайлов.PDF Тогда
			ФорматКартинки = Строка(ФорматСканированногоИзображения);
			
			Представление = Представление + НСтр("ru = 'Формат хранения:'") + " ";
			Представление = Представление + "PDF";
			Представление = Представление + ". ";
			Представление = Представление + НСтр("ru = 'Формат сканирования:'") + " ";
			Представление = Представление + ФорматКартинки;
			Представление = Представление + ". ";
		Иначе	
			ФорматКартинки = Строка(ФорматХраненияОдностраничный);
			Представление = Представление + НСтр("ru = 'Формат хранения:'") + " ";
			Представление = Представление + ФорматКартинки;
			Представление = Представление + ". ";
		КонецЕсли;
	Иначе	
		ФорматКартинки = Строка(ФорматСканированногоИзображения);
		Представление = Представление + НСтр("ru = 'Формат хранения:'") + " ";
		Представление = Представление + ФорматКартинки;
		Представление = Представление + ". ";
	КонецЕсли;

	Если ВРег(ФорматКартинки) = "JPG" Тогда
		Представление = Представление +  НСтр("ru = 'Качество:'") + " " + Строка(КачествоJPG) + ". ";
	КонецЕсли;	
	
	Если ВРег(ФорматКартинки) = "TIF" Тогда
		Представление = Представление +  НСтр("ru = 'Сжатие:'") + " " + Строка(СжатиеTIFF) + ". ";
	КонецЕсли;
	
	Представление = Представление + НСтр("ru = 'Формат хранения многостраничный:'") + " ";
	Представление = Представление + Строка(ФорматХраненияМногостраничный);
	Представление = Представление + ". ";
	
	Представление = Представление + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Разрешение: %1 dpi. %2.'") + " ",
		Строка(Разрешение), Строка(ЦветностьПеречисление));
	
	Если НЕ ПоворотПеречисление.Пустая() Тогда
		Представление = Представление +  НСтр("ru = 'Поворот:'")+ " " + Строка(ПоворотПеречисление) + ". ";
	КонецЕсли;	
	
	Если НЕ РазмерБумагиПеречисление.Пустая() Тогда
		Представление = Представление +  НСтр("ru = 'Размер бумаги:'") + " " + Строка(РазмерБумагиПеречисление) + ". ";
	КонецЕсли;	
	
	Если ДвустороннееСканирование = Истина Тогда
		Представление = Представление +  НСтр("ru = 'Двустороннее сканирование'") + ". ";
	КонецЕсли;	
	
	ТекстНастроек = Представление;
	
	Элементы.ТекстНастроекИзменить.Заголовок = ТекстНастроек + "Изменить";
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
#Если НЕ ВебКлиент Тогда
		
	Если Источник = "TWAIN" И Событие = "ImageAcquired" Тогда
		
		ИмяФайлаКартинки = Данные;
		Элементы.Сохранить.Доступность = Истина;
		
		КоличествоСтрокДоДобавления = ТаблицаФайлов.Количество();
		
		СтрокаТаблицы = Неопределено;
		
		Если ПозицияДляВставки = Неопределено Тогда
			СтрокаТаблицы = ТаблицаФайлов.Добавить();
		Иначе
			СтрокаТаблицы = ТаблицаФайлов.Вставить(ПозицияДляВставки);
			ПозицияДляВставки = ПозицияДляВставки + 1;
		КонецЕсли;
		
		СтрокаТаблицы.ПутьКФайлу = ИмяФайлаКартинки;
		
		Если НарастающийНомерИзображения = Неопределено Тогда
			НарастающийНомерИзображения = 1;
		КонецЕсли;
			
		СтрокаТаблицы.Представление = "Изображение" + Строка(НарастающийНомерИзображения);
		НарастающийНомерИзображения = НарастающийНомерИзображения + 1;
		
		Если КоличествоСтрокДоДобавления = 0 Тогда
			ПутьКВыбранномуФайлу = СтрокаТаблицы.ПутьКФайлу;
			ДвоичныеДанные = Новый ДвоичныеДанные(ПутьКВыбранномуФайлу);
			АдресКартинки = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
			СтрокаТаблицы.АдресКартинки = АдресКартинки;
		КонецЕсли;
		
		Если ТаблицаФайлов.Количество() > 1 И Элементы.ТаблицаФайлов.Видимость = Ложь Тогда
			Элементы.ТаблицаФайлов.Видимость = Истина;
			Элементы.ФормаПринятьВсеКакОдинФайл.Видимость = Истина;
			Элементы.ФормаПринятьВсеКакОтдельныеФайлы.Видимость = Истина;
			Элементы.Сохранить.Видимость = Ложь;
		КонецЕсли;
		
		Если ТаблицаФайлов.Количество() > 1 Тогда
			Элементы.ТаблицаФайловКонтекстноеМенюУдалить.Доступность = Истина;
		КонецЕсли;
		
	ИначеЕсли Источник = "TWAIN" И Событие = "EndBatch" Тогда
		
		Если ТаблицаФайлов.Количество() <> 0 Тогда
			ИдентификаторСтроки = ТаблицаФайлов[ТаблицаФайлов.Количество() - 1].ПолучитьИдентификатор();
			Элементы.ТаблицаФайлов.ТекущаяСтрока = ИдентификаторСтроки;
		КонецЕсли;
		
	ИначеЕсли Источник = "TWAIN" И Событие = "UserPressedCancel" Тогда	
		Если ЭтотОбъект.Открыта() Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура УдалитьВременныеФайлы(ТаблицаЗначенийФайлов)
	
	Для Каждого Строка Из ТаблицаЗначенийФайлов Цикл
		УдалитьФайлыАсинх(Строка.ПутьКФайлу);
	КонецЦикла;
	
	ТаблицаЗначенийФайлов.Очистить();
	ПозицияДляВставки = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Функция ТекстСообщенияОшибкиПреобразованияВPDF(ФайлРезультата)
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не найден файл ""%1"".
		           |Проверьте, что установлена программа ImageMagick и
		           |указан правильный путь к программе преобразования в
		           |PDF в форме настроек сканирования.'"),
		ФайлРезультата);
		
	Возврат ТекстСообщения;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьПараметрыСканера(РазрешениеЧисло, ЦветностьЧисло, ИдентификаторКлиента) 
	
	Результат = ФайловыеФункцииСлужебный.ПараметрыСканераВПеречисления(РазрешениеЧисло, ЦветностьЧисло, 0, 0);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиСканирования/Разрешение", ИдентификаторКлиента, Результат.Разрешение);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиСканирования/Цветность", ИдентификаторКлиента, Результат.Цветность);
	
КонецПроцедуры

#КонецОбласти
