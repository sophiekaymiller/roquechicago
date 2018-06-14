

    "rules":{
        "user":{
          "$uid":,
          "username":,
          "status":,
          "is_verified": 
          "is_temporary":,
          "profile": {
            "$salon_id":,
            "status":,
            "role":{
              "1": "Owner",
              "2": "Manager",
              "3": "Employee",
              "4": "Customer",
            },
            "fullname": {"type": "string"},
            "nickname": {"type": "string"},
            "social_security_number": {"type": "string", "optional": true}, //Bring outside?
            "salary_rate": {"type": "double", "optional": true},
            "cash_rate": {"type": "double", "optional": true},
            "birthday": {"type": "string", "optional": true},//Bring outside?
            "address": {"type": "string", "optional": true}, //Bring outside?
            "phone": {"type": "phone"} //Bring outside?
          },
          "appointment": {
            "appointment_id": {"type": "string"},
            "salon_id": {"type": "string"},
            "comment": {"type": "string"},
            "device":{
              "type": "number",
              "1": "phone",
              "2": "web",
              "3": "app",
            },
            "appointment_items": {
              "type": "array",
              "employee_id": {"type": "string"},
              "service":{
                "service_id": {"type": "string"},
                "service_name": {"type": "string"},
                "time": {"type": "number"},
                "price": {"type": "number"},
              },
              "start": "SalonTime",
              "overlapped":{
                "status" : {"type": "boolean"},
                "appointment_id": {"type": "string", "optional": true} 
              },
              "customer_id":{
              "type": "string", 
              "status": {
                "type": "number",
                "1": "booked",
                "2": "check-in",
                "3": "in-process",
                "4": "done",
                "5": "paid",
                },
                "type": "number",
                "1": "booking",
                "2": "check-in",
                "is_reminded": {"type": "boolean"},
              },
          },
        },
      /*        

      "discount":,
      "finance":,
      "giftcard":,
      "weeklySchedule":{
        "_id": {"type": "string"}, //database id
        "salon_id": {"type": "string"},
        "employee_id": {"type": "string"},
        "week": {
          "type": "array",
          "close": {"type": "number"},
          "open": {"type": "number"},
          "status": {"type": "boolean"},
          "day_of_week": {"type": "number"},
        },
      },
      "dailySchedule":{
        "_id": {"type": "string"},
        "salon_id": {"type": "string"},
        "employee_id": {"type": "string"},
        "day":{
          "close": {"type": "number"},
          "open": {"type": "number"},
          "status": {"type": "boolean"},
          "date": {"type": "number"},
        },
      },
         "salon":{
        "id": {"type": "string"},
        "setting": {
          "appointment_reminder": {"type": "boolean"},
          "flexible_time": {"type": "number"},
          "technician_checkout": {"type": "boolean"},
        },
        "information":{
          "salon_name":{"type": "string"},
          "phone": {
            "number": {"type": "string"},
            "is_verified": {"type": "boolean"},
          },
          "location":{
            "address": {"type": "string"},
            "is_verified": {"type": "boolean"},
          },
          "email": "string",
        }
      },
      "domain":
      }
    }
    
    

> Written with [StackEdit](https://stackedit.io/).

