{% macro print_cloud_env() %}
{% do exceptions.raise_compiler_error('TYPE=' ~ env_var('DBT_CLOUD_ENVIRONMENT_TYPE', 'not set') ~ ' CONTEXT=' ~ env_var('DBT_CLOUD_INVOCATION_CONTEXT', 'not set')) %}
{% endmacro %}