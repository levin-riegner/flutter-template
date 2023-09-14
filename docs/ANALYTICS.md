# Analytics

This document describes best practices and styles for using Google Analytics.

## Tracking Events

Use a spreadsheet to track all events that are tracked in the app.
You can use [this template](https://docs.google.com/spreadsheets/d/1yEgTKGOUVgUlfWrG-qjul5ers80qcINw4UcisZoMSD8/edit?usp=sharing) containing all recommended events.

### Style Guide

- Event names must be in `snake_case`.
- Parameter names must be in `snake_case`.
- Parameter values should be in `snake_case`, but may be in other formats if necessary.

### Recommended Events

The following events are recommended for all apps:

| Event Name | Parameters | Description |
| ---------- | ---------- | ----------- |
| `app_open` | | The app is opened. |
| `login` | `method` | The user logs in. |
| `sign_up` | `method` | The user signs up. |
| `delete_account` | | The user deletes their account. |
| `logout` | | The user logs out. |
| `share` | `content_type`, `item_id` | The user shares content. |
| `search` | `search_term` | The user searches for content. |
| `url_view` | `url` | The user views a URL. |
| `screen_view` | `firebase_screen`, `firebase_screen_class` | The user views a screen. |
| `campaign_details` | `source`, `medium`, `campaign` | The user opens the app with a link containing UTM parameters. |

Some of the above events are already defined in the Google Analytics SDK. You can see the full list of pre-defined GA events [here](https://support.google.com/analytics/answer/9267735?hl=en).

Other events are automatically collected by the Google Analytics SDK. You can see the full list [here](https://support.google.com/analytics/answer/9234069?hl=en).

### Custom Events

Before you create a custom event, make sure the event you want to create isn't already collected through an automatically collected event or recommended as a recommended event. It's always better to use an existing event because these events automatically populate dimensions and metrics that are used in your reports.

The event name should describe what you intend to measure with the event. For example, if you're measuring donations, the name might be "donate".

The event parameters of a custom event provide more information about the action that took place.

To access the different values assigned to an event parameter in your reports, you should create a custom dimension or metric. A custom dimension or metric lets you see the information you collected from an event parameter. For example, if you set up a 'value' event parameter, you could create a custom metric called 'Value' that allows you to see each value assigned to the event parameter.

As a best practice, prefer multiple events with fewer parameters over fewer events with more parameters. This makes it easier to analyze the data in your reports.

You can see more information about custom events [here](https://support.google.com/analytics/answer/12229021?hl=en).

### Screen Views

Screen views should be tracked using the `screen_view` event. The `firebase_screen` parameter should be set to the name of the screen. The `firebase_screen_class` parameter should be set to the name of the screen class.

- `firebase_screen` is a string that represents the resolved URL of the screen, without placeholders. For example, if the route path is `/home/items/:id`, the value should be `home/items/123`.
- `firebase_screen_class` is a string that represents the name of the first widget created for the route. For example `ItemDetailPage`.

### User Properties

User properties are attributes that describe groups of your user base, such as their language preferences or geographic locations. You can use user properties to define audiences.

Some properties are automatically collected by the Google Analytics SDK.

Additional properties can be set manually. For example, you might want to set a user property to indicate whether a user has a paid account. A user-scoped custom dimension needs to be created to access the value of the user property.

Properties should never contain personally identifiable information. For example, you should not set a property to the user's email address.

You can see more information about user properties [here](https://support.google.com/analytics/answer/9355671?hl=en).

### Limits

- Events are capped at 500 distinct per user per day.
- Event names must be 40 characters or less.
- Parameters are capped at 25 per event.
- Parameter Names must be 40 characters or less.
- Parameter Values must be 100 characters or less.
- User properties are capped at 25.
- User property Names must be 24 characters or less.
- User property Values must be 36 characters or less.

You can see the full list of limits [here](https://support.google.com/analytics/answer/9267744?hl=en).

## Asking the User for Permission

Analytics must be disabled by default, and opted in to comply with GDPR.
The user should be asked for permission to collect analytics data when they register/login or open the app.

If the events are also used for tracking purposes (ie: facebook ads), the user must also opt-in to tracking before collecting any data.

## Visualizing Data

Data can be visualized using the Google Analytics dashboard. However, the dashboard can be cumbersome to use. It's recommended to use Looker Studio to create custom dashboards and reports.

### Path Exploration

The path exploration report can be used to visualize the paths users take through the app. This can be used to identify the most common paths, and the paths that lead to the most conversions.

You can see more information about path exploration [here](https://support.google.com/analytics/answer/9317498?hl=en).
