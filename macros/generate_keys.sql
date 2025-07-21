{% macro generate_surrogate_key(field_list) %}
  {{ return(adapter.dispatch('generate_surrogate_key', 'planetkart')(field_list)) }}
{% endmacro %}

{% macro default__generate_surrogate_key(field_list) %}
  {{ return("md5(concat(" ~ field_list|join(", '|', ") ~ "))") }}
{% endmacro %}