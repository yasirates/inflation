managed implementation in class zbp_inf_i_users unique;
strict ( 2 );

define behavior for ZINF_I_USERS //alias <alias_name>
persistent table zinf_users
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;


  mapping for zinf_users
    {
      ServiceId  = service_id;
      ServiceUrl = service_url;
      Username   = username;
      Password   = password;
    }
}