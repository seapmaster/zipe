////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Процедуры и функции для работы с журналом регистрации.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура пакетной записи сообщений в журнал регистрации.
// 
// Параметры:
//  СобытияДляЖурналаРегистрации - СписокЗначений, клиентская глобальная переменная.
//     После записи переменная очищается.
Процедура ЗаписатьСобытияВЖурналРегистрации(СобытияДляЖурналаРегистрации) Экспорт
	
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СобытияДляЖурналаРегистрации);
	
КонецПроцедуры

#КонецОбласти
