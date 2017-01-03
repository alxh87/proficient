User.create!([
    {email: "alxh87@gmail.com", encrypted_password: "$2a$10$hOJLf6PsY2u0x6yZtN5LL.FrZsC/wRbkMe2u50Ky8pGna5o.8iL/W", confirmation_token: "6a873de59fc0a9c96c3a38531c1be46f96e7cbc3", remember_token: "a5afd2270a0dba202281b0c8c7df4b69bd671f36"}
])
ActiveNumber.create!([
  {area: "sales", name: "Juarez", number: "+61407027111"},
  {area: "support", name: "Juarez", number: "+61407027118"},
  {area: "officehours", name: "startday", number: "1"},
  {area: "officehours", name: "endday", number: "5"},
  {area: "officehours", name: "starttime", number: "09"},
  {area: "officehours", name: "endtime", number: "18"}
])
SalesNumber.create!([
  {name: "Juarez", number: "+61407027118"}
])
SupportNumber.create!([
  {name: "Juarez", number: "+61407027118"}
])
