# Schedules

### GET Daily Schedule

Required Parameters

    salon_id=<salon_id>&start_date=<start_date>&end_date=<end_date>
    <start_date>, <end_date>: 'YYYY-MM-DD HH:mm:ss'

//Database Content
{
  

    "daily_schedules": 
    	[
        {
            "date": "YYYY-MM-DD HH:mm:ss",
            "status": "boolean",
            "open": "number",
            "close": "number" 
        }                               
        //...
     	]
    } 

// GET Weekly Schedule
//Parameters salon_id=\<salon_id>

    { 
    "weekly_schedules": [
           {
              "status": "boolean",
               "open": "number", //range(0..24 * 3600),
               "close": "number", //range(0..24 * 3600)
               "day_of_week": 0
           },
           {
               "status": "boolean",
               "open": "number",// range(0..24 * 3600),
               "close": "number",// range(0..24 * 3600),
               "day_of_week": 1
           },
           {
               "status": "boolean",
               "open": "number", //range(0..24 * 3600),
               "close": "number", //range(0..24 * 3600),
               "day_of_week": 2
           },
           {
               "status": "boolean",
               "open": "number", //range(0..24 * 3600),
               "close": "number", //range(0..24 * 3600),
               "day_of_week": 3
           },
           {
               "status": "boolean",
               "open": "number",// range(0..24 * 3600),
               "close": "number",// range(0..24 * 3600),
               "day_of_week": 4
           },
           {
               "status": "boolean",
               "open": "number", //range(0..24 * 3600),
               "close": "number",//range(0..24 * 3600), 
               "day_of_week": 5 
           },
           { 
           	   "status": "boolean", 
               "open": "number", //range(0..24 * 3600), 
               "close": "number", //range(0..24 * 3600), 
               "day_of_week": 6 
               }
    ] }

SAVE Schedules
POST Daily Schedule
schedule/savedailyschedule

parameters - **Authorization token**


    {
      "savedailyschedule": 
        {
        	"salon_id": "string",
            "date": "YYYY-MM-DD HH:mm:ss",
            "status": "boolean",
            "open": "number",
            "close": "number" 
        }                               
                         
    } 

database response (if successful)

      {          
          "_id": "String"                 
      }

schedule/saveweeklyschedule

    {
    "salon_id": "salonId", 
    "weekly_schedules": 
    [
           {
              "status": "boolean",
               "open": "number", //range(0..24 * 3600),
               "close": "number", //range(0..24 * 3600)
               "day_of_week": 0
           },
           {
               "status": "boolean",
               "open": "number",// range(0..24 * 3600),
               "close": "number",// range(0..24 * 3600),
               "day_of_week": 1
           },
           {
               "status": "boolean",
               "open": "number", //range(0..24 * 3600),
               "close": "number", //range(0..24 * 3600),
               "day_of_week": 2
           },
           {
               "status": "boolean",
               "open": "number", //range(0..24 * 3600),
               "close": "number", //range(0..24 * 3600),
               "day_of_week": 3
           },
           {
               "status": "boolean",
               "open": "number",// range(0..24 * 3600),
               "close": "number",// range(0..24 * 3600),
               "day_of_week": 4
           },
           {
               "status": "boolean",
               "open": "number", //range(0..24 * 3600),
               "close": "number",//range(0..24 * 3600), 
               "day_of_week": 5 
           },
           { 
           	   "status": "boolean", 
               "open": "number", //range(0..24 * 3600), 
               "close": "number", //range(0..24 * 3600), 
               "day_of_week": 6 
               }
    ] 
    }

database response (if successful)

   {          
      "_id": "String"                 
   }

//TODO: GET/POST Employee Daily Schedule

schedule/getemployeedailyschedule
schedule/saveemployeedailyschedule

    URL salon_id=<salon_id>&employee_id=<employee_id>&start_date=<start_date>&end_date=<end_date>

//TODO: GET/POST Employee Weekly Schedule

schedule/getemployeeweeklyschedule
schedule/saveemployeeweeklyschedule
`URL salon_id=<salon_id>&employee_id=<employee_id>&start_date=<start_date>&end_date=<end_date>`








> Written with [StackEdit](https://stackedit.io/).


<!--stackedit_data:
eyJoaXN0b3J5IjpbODM4NDA4OTM4XX0=
-->