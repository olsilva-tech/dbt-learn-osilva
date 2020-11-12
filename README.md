Welcome to your new Orlando Silva dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices



### Others:
with 

{%- set available_payment_methods -%}
select distinct payment_method from {{ ref('stg_payments') }}
{%- endset -%}

{%- set payment_methods = run_query(available_payment_methods) -%}

{%- if execute -%}
{%- set payment_methods_list = payment_methods.columns[0].values() -%}
{%- else -%}
{%- set payment_methods_list = [] -%}
{%- endif -%}


{%- set payment_methods_list_macro = dbt_utils.get_column_values(table=ref('stg_payments'), column='payment_method') -%}


payments as (
select * from {{ ref('stg_payments') }}
), pivot as (
  -- can we omit the comma on the final element?
  -- can we automatically get all the values in the column dynamically?
  select
    order_id,
    {%- for pm in payment_methods_list_macro -%}
    sum(case when payment_method = '{{ pm }}' then amount else 0 end) as {{ pm }}_amount
    {{ "," if not loop.last }}
    {%- endfor -%}
  from payments
  group by order_id
)

select *
from pivot



### How To generate staging models based on the sources:

https://hub.getdbt.com/fishtown-analytics/codegen/latest/
{{ codegen.generate_base_model(source_name='ticket_tailor', table_name='orders') }}