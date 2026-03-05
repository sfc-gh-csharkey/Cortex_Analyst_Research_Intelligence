# Cortex Analyst Examples using synthetic Financial Services data
<img width="85" alt="map-user" src="https://img.shields.io/badge/views-053-green"> <img width="125" alt="map-user" src="https://img.shields.io/badge/unique visits-003-green">

Cortex Analyst is a service that provides text to SQL capabilities on your data. Using the analyst service, you model your data in a way that an LLM can best understand it. Specifically you build semantic views (previously semantic models).

Semantic views can include multiple tables, views etc. of data. The key inputs when defining a semantic view include:

* Tables
* Dimensions
* Time Dimensions
* Facts (measures)
* Relationships
* Filters
* Verified query repository

Not all of these inputs are required. Defining these different properties, you document key information about how your data is used, which in turn an LLM can use for text to SQL.

## How to deploy / use the code sample(s)

This repository assumes you have deployed the sample [Sample Financial Services Data](https://github.com/sfc-gh-csharkey/Sample_Data_Financial_Services) or at least the portions of it that are applicable to the search service you are trying to deploy.

Each example has a folder. Each folder has a ```.sql``` and ```.yaml``` file.

For example the [Trading_Analytics](https://github.com/sfc-gh-csharkey/Cortex_Analyst_FSI_Examples/tree/main) folder has [trading_analytics_create_semantic_view.sql](https://github.com/sfc-gh-csharkey/Cortex_Analyst_FSI_Examples/blob/main/Trading_Analytics/trading_analytics_create_semantic_view.sql) and [trading_analytics_semantic_model.yaml](https://github.com/sfc-gh-csharkey/Cortex_Analyst_FSI_Examples/blob/main/Trading_Analytics/trading_analytics_semantic_model.yaml).

To create the semantic view run the ```.sql``` file. The ```.yaml``` file represents the same information in the ```.sql``` file just in YAML.

The semantic view can be invoked different way including but not limited to: by a Cortex Agent, Python library, API etc.

The semantic view can also be tested via. the Snowsight UI playground.

To access the playground select AI/ML services from the side bar, then analyst, the select the name of the semantic view. You may need to select the database and schema that the view belongs to.

<img width="900" alt="quick_setup" src="https://github.com/sfc-gh-csharkey/Cortex_Analyst_FSI_Examples/blob/main/READ_ME/Screenshot%202026-03-04%20at%208.57.12%E2%80%AFAM.png">

Select the playground option and enter your prompt / question in the chat window

<img width="900" alt="quick_setup" src="https://github.com/sfc-gh-csharkey/Cortex_Analyst_FSI_Examples/blob/main/READ_ME/Screenshot%202026-03-04%20at%208.58.28%E2%80%AFAM.png">
