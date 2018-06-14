


/*

## Roque Salon Scheduling App Data Scheme -  Sophie Miller **2017**

"**required**" Data
    
    { 
     "username": "required", 
     "password": "required" 
    } 
    //Database response
    {
     "user":{
            "id": "string",
            "username": "string", 
            "fullname": "string",
            "salon_id": "string"
         },
    "auth":{
            "token": "string",
            "expire": "timestamp" 
         }
    	
    }
    
   

 Authentication with custom token
   "required" Data
    
    { 
     "custom_token": "string", "required"
    } 
    //Database response
    { 
      "user":{
                "id": "string",
                "username": "string", 
                "fullname": "string",
                "salon_id": "string"
             },
      "auth":{
                "token": "string",
                "expire": "timestamp" 
             }
    }

