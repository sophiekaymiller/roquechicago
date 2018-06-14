# Sophie Miller 2017 Roque Salon Management


**

## /salon /salon/create, create new Salon

** 

## Authorization Token

    
    {
    	"salon_name": {"type": "required", "string"},
    	"address": {"type": "required", "string"},  //Google Format, TODO - Set up with Google places API 
    	"phonenumber": {"type": "required", "string"},
    	"email": "optional",
    	
    }
    

## //if successful:

    
    {
    	"id": "required", "string"
    	"salon_name": {"type": "required", "string"},
    	"address": {"type": "required", "string"},  //Google Format, TODO - Set up with Google places API 
    	"phonenumber": {"type": "required", "string"},
    	"email": "optional",	
    }
    
    // /salon/updateinfo, update existing salon info
    

## //Parameters

    {
    	"id": "required",
    	"salon_name": {"type": "required", "string"},
    	"address": {"type": "required", "string"},  //Google Format, TODO - Set up with Google places API 
    	"phonenumber": {"type": "required", "string"},
    	"email": "optional",
    }
    
    //response if successful
    {
    	"id": "required" //all fields updated
    	//need date?
    }
    
    //GET salon list by user (uid)
    //salon/getsalonlist
    
    //Parameters - Auth token UID
    
    {
    	"salon_list":
    	[
    	{
    		"salon_id": "required",
    		"salon_name": "required",
    		"role": "required",
    		"phone": "required",
    		"address": "optional"
    	}
    	]
    }
    

## //GET salon info

    
    //salon/getinfo
    //URL ?salonid=<salonid> determined on initial auth
    {
    	"name":,
    	"phone":,
    	"location":,
    	"email":
    }
    
    //GET salon settings
    //URL ?salonid=<salonid> determined on initial auth
    //Params: Auth token (permissions to Owner)
    
    //response
    {
    	"appointment_reminder": "boolean",
    	"flexible_time": "number"
    }
    

<!--stackedit_data:
eyJoaXN0b3J5IjpbOTkwODE0NTY3XX0=
-->