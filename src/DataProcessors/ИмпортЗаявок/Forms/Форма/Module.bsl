#Область ПеременныхМодуля

#Если Сервер Тогда
Перем ТекСтруктураДанных;
Перем ТекИмяФайла;
#КонецЕсли

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПреобразоватьВЧисло(Знач СтрЧисло);
	
	СтрокаЧисел = "0123456789";
	
	ТекЧисло = "0";
	
	Для к =1 По СтрДлина(СтрЧисло) Цикл
		
		ТекСимв = Сред(СтрЧисло,к,1);
		
		Если Найти(СтрокаЧисел,ТекСимв) Тогда
		
			ТекЧисло = ТекЧисло + ТекСимв;
			
		ИначеЕсли ТекСимв = "." ИЛИ ТекСимв = "," Тогда
			
			ТекЧисло = ТекЧисло + ТекСимв;
		
		ИначеЕсли ТекСимв = "-" И ТекЧисло = "0" Тогда
			
			ТекЧисло = "-0";
		
		КонецЕсли; 
	
	КонецЦикла; 
	
	Попытка
		ПреобразованноеЧисло = Число(ТекЧисло);
	Исключение
		ПреобразованноеЧисло = 0;
	КонецПопытки; 
	
	
	Возврат ПреобразованноеЧисло;
	
КонецФункции

&НаСервере
Процедура ЗаписатьВЛог(ГУИД,Ссылка,ИдентификаторСтроки=Неопределено,Описание,СтруктураДанных=Неопределено)
	
	МЗ = РегистрыСведений.ЛогЗагрузки.СоздатьМенеджерЗаписи();
	МЗ.ГУИД = ГУИД;
	МЗ.Файл = "" + ПутьКФайлу + ?(ТекИмяФайла="","","\"+ТекИмяФайла);
	МЗ.Объект1С = Ссылка;
	МЗ.Период = ТекущаяДата();
	МЗ.ИдентификаторСтроки = ИдентификаторСтроки;
	МЗ.Описание = Описание;
	МЗ.СтруктураДанных = СтруктураДанных;
	МЗ.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти


#Область ЗагрузкаДанных

&НаСервере
Функция ИзвлечьХМЛИзАрхива(Вложение)
	
	ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
	ДвоичныеДанные = Вложение.Получить();
	
	Если ДвоичныеДанные = Неопределено Тогда
		Возврат "";
	КонецЕсли; 
	
	ДвоичныеДанные.Записать(ИмяАрхива);
	
	// Распаковываем файлы
	ЧтениеЗИП = Новый ЧтениеZipФайла(ИмяАрхива);
	
	ПолныйПуть = "";
	
	Для каждого ТекАрхив Из ЧтениеЗИП.Элементы Цикл
		// файл не xml пропускаем
		Если СтрНайти(ТекАрхив.Расширение, "xml") > 0 Тогда
			
			ВремКаталог = КаталогВременныхФайлов();
			ПолныйПуть = ВремКаталог + ТекАрхив.Имя;
			
			ЧтениеЗИП.Извлечь(ТекАрхив, ВремКаталог);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЧтениеЗИП.Закрыть();
	
	ДвДанные = Новый ДвоичныеДанные(ПолныйПуть);
	
	УдалитьФайлы(ИмяАрхива);
	УдалитьФайлы(ПолныйПуть);
	
	Возврат ПоместитьВоВременноеХранилище(ДвДанные);
	
КонецФункции

&НаСервере
Процедура ЗагрузитьНаСервере(АдресФайла, ДополнительныеПараметры)
	
	Вложение = Неопределено;
	Если ДополнительныеПараметры.Свойство("ВыбранноеИмяФайла") Тогда
		ВыбранноеИмяФайла = ДополнительныеПараметры.ВыбранноеИмяФайла;
		ВыбранноеИмяФайлаДвДанные = ДополнительныеПараметры.ВыбранноеИмяФайлаДвДанные;
		
		Если СтрНайти(ВыбранноеИмяФайла, "zip") > 0 Тогда
			Вложение = Новый ХранилищеЗначения(ВыбранноеИмяФайлаДвДанные);
			АдресХМЛФайла = ИзвлечьХМЛИзАрхива(Вложение);
		Иначе
			АдресХМЛФайла = ПоместитьВоВременноеХранилище(ВыбранноеИмяФайлаДвДанные);
		КонецЕсли; 
	КонецЕсли; 
		
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Адрес", АдресХМЛФайла);
	ДопПараметры.Вставить("Вложение", Вложение);
		
	Результат = ОбменСИнформационнымиСистемами.ПрочитатьXMLФайлЗапросыИЗаявки(ДопПараметры);
	
	Если Результат.Выполнено Тогда
		Сообщить("Загрузка успешно завершена");
	Иначе
		Сообщить(Результат.Описание);
	КонецЕсли; 
		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЗаявки(Команда)
	
	АдресФайла = "";
	
	Если НЕ ЗначениеЗаполнено(ПутьКФайлу) Тогда
		ПоказатьПредупреждение(, "Не указан путь к файлу", 4);
		Возврат;
	КонецЕсли; 

	НачатьПомещениеФайла(Новый ОписаниеОповещения("ОбработкаПомещенияФайла", ЭтотОбъект, Новый Структура("КоличествоФайлов,НомерФайла,ТекущийФайл",1,1,"")), АдресФайла, ""+ПутьКФайлу+"",Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПомещенияФайла(Результат, АдресФайла, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Состояние("" + ТекущаяДата() + " Загружается: " + ДополнительныеПараметры.ТекущийФайл,Цел(100/ДополнительныеПараметры.КоличествоФайлов*ДополнительныеПараметры.НомерФайла));

	ДополнительныеПараметры.Вставить("ВыбранноеИмяФайла", ВыбранноеИмяФайла);
	ДополнительныеПараметры.Вставить("ВыбранноеИмяФайлаДвДанные", Новый ДвоичныеДанные(ВыбранноеИмяФайла));
	
	ЗагрузитьНаСервере(АдресФайла, ДополнительныеПараметры);
    
КонецПроцедуры

#КонецОбласти


#Область ОбработкаСобытийФормы

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	
	СтандартнаяОбработка = Ложь;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.ПолноеИмяФайла = ПутьКФайлу;
	Диалог.Фильтр = "XML|*.xml|ZIP|*.zip";
	Диалог.МножественныйВыбор = Ложь;
	
    Диалог.Показать(Новый ОписаниеОповещения("ОбработкаВыборафайла", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыборафайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
    
	Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() > 0 Тогда
		ПутьКФайлу = ВыбранныеФайлы[0];
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти
