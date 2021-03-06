////////////////////////////////////////////////////////////////////////////////
// Модуль содержит серверные процедуры и функции общего назначения с повторным использованием возвращаемых значений
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ПрочиеПроцедурыИФункции

// Проверяет необходимость фиксации истории изменения объектов при начальном заполнении базы.
// При начальном заполнении базы нельзя фиксировать историю изменения, т.к. параметр сеанса ТекущийПользователь еще не определен и попытка его определить приводит к ошибкам.
//
// Возвращаемое значение:
//  Булево - Истина, если фиксация истории изменения объектов доступна
//
Функция ПроверитьНеобходимостьФиксацииИсторииИзмененияОбъектовПриНачальномЗаполненииБазы() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВерсииПодсистем.ИмяПодсистемы
	|ИЗ
	|	РегистрСведений.ВерсииПодсистем КАК ВерсииПодсистем";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		// Не заполнена ни одна из версий стандартных подсистем, значит это начальное заполнение ИБ
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецОбласти