User.create!([
    {email: "alxh87@gmail.com", encrypted_password: "$2a$10$hOJLf6PsY2u0x6yZtN5LL.FrZsC/wRbkMe2u50Ky8pGna5o.8iL/W", confirmation_token: "6a873de59fc0a9c96c3a38531c1be46f96e7cbc3", remember_token: "a5afd2270a0dba202281b0c8c7df4b69bd671f36"}
])
ActiveNumber.create!([
  {area: "sales", name: "Juarez", number: "+61407027111"},
  {area: "support", name: "Alex", number: "+61405454187"},
  {area: "officehours", name: "startday", number: "2"},
  {area: "officehours", name: "endday", number: "4"},
  {area: "officehours", name: "starttime", number: "10"},
  {area: "officehours", name: "endtime", number: "13"}
])
SalesNumber.create!([
  {name: "Juarez", number: "+61407027111"},
  {name: "Juarez", number: "+61407027112"}
])
SupportNumber.create!([
  {name: "Alex", number: "+61405454187"},
  {name: "Alex", number: "+61405454181"}
])
