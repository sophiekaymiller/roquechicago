
## appointment
    {
      "appointment" : {
        "appointment_id" : "",
        "appointment_items" : {
          "1" : "booking",
          "2" : "check-in",
          "customer_id" : "",
          "employee_id" : "",
          "is_reminded" : false,
          "overlapped" : {
            "appointment_id" : "",
            "status" : ""
          },
          "service" : {
            "price" : "",
            "service_id" : "",
            "service_name" : "",
            "time" : ""
          },
          "start" : "SalonTime",
          "status" : [ null, "booked", "check-in", "in-process", "done", "paid" ],
          "type" : "number"
        },
        "comment" : "",
        "device" : {
          "1" : "phone",
          "2" : "web",
          "3" : "app",
          "type" : "number"
        },
        "payments" : {
          "discount" : false,
          "finance" : "",
          "giftcard" : ""
        },
        "salon_id" : "",
        "schedules" : {
          "weeklySchedule" : {
            "_id" : "",
            "dailySchedule" : {
              "_id" : "",
              "day" : {
                "close" : "",
                "date" : "",
                "open" : "",
                "status" : ""
              },
              "employee_id" : "",
              "salon_id" : ""
            },
            "employee_id" : "",
            "salon" : {
              "id" : "",
              "information" : {
                "email" : "",
                "location" : {
                  "address" : "",
                  "is_verified" : ""
                },
                "phone" : {
                  "is_verified" : "",
                  "number" : ""
                },
                "salon_name" : ""
              },
              "setting" : {
                "appointment_reminder" : "",
                "flexible_time" : "",
                "technician_checkout" : ""
              }
            },
            "salon_id" : "",
            "week" : {
              "close" : "",
              "day_of_week" : "",
              "open" : "",
              "status" : "",
              "type" : "array"
            }
          }
        }
      },
 

 ## Profile
  
      "profile" : {
        "address" : "",
        "birthday" : "",
        "cash_rate" : 0,
        "fullname" : "",
        "nickname" : "",
        "phone" : "",
        "role" : [ null, "Owner", "Manager", "Employee", "Customer" ],
        "salary_rate" : 0,
        "salon_id" : "",
        "social_security_number" : "",
        "status" : "",
        "uid" : ""
      },
 

 ## user
      "user" : {
        "is_temporary" : false,
        "is_verified" : false,
        "status" : "",
        "uid" : "",
        "username" : ""
      }
    }

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTI1Mzg2ODY1N119
-->