ActiveNumber.create!([
	{area: "support", name: "Juarez", number: "+61407027118"},
  {area: "sales", name: "Juarez", number: "+61407027111"}
])
SalesNumber.create!([
  {name: "Juarez", number: "+61407027118"}
])
SupportNumber.create!([
  {name: "Juarez", number: "+61407027118"}
])
OfficeHour.create!([
  {id: 1, name: "startday", number: "1"},
  {id: 2, name: "endday", number: "5"},
  {id: 3, name: "starttime", number: "9"},
  {id: 4, name: "endtime", number: "18"}
])