---


---

<p>/*</p>
<h2 id="roque-salon-scheduling-app-data-scheme----sophie-miller-2017">Roque Salon Scheduling App Data Scheme -  Sophie Miller <strong>2017</strong></h2>
<p>“<strong>required</strong>” Data</p>
<pre><code>{ 
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
</code></pre>
<p>Authentication with custom token<br>
"required" Data</p>
<pre><code>{ 
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
</code></pre>

