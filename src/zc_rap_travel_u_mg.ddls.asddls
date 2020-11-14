@EndUserText.label: 'Travel Data'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
define root view entity ZC_RAP_TRAVEL_U_MG
  as projection on ZI_RAP_TRAVEL_U_MG
{
      //ZI_RAP_TRAVEL_U_MG
  key TravelID,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ { entity: { name: '/DMO/I_Agency', element: 'AgencyID' } } ]
      AgencyID,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ { entity: { name: '/DMO/I_Customer', element: 'CustomerID' } } ]
      CustomerID,
      BeginDate,
      EndDate,
      BookingFee,
      TotalPrice,
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_Currency', element: 'Currency' } } ]
      CurrencyCode,
      Description,
      Status,
      Createdby,
      Createdat,
      Lastchangedby,
      Lastchangedat,
      /* Associations */
      //ZI_RAP_TRAVEL_U_MG
      _Agency,
      _Booking : redirected to composition child ZC_RAP_BOOKING_U_MG,
      _Currency,
      _Customer
}
