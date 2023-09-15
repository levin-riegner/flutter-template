# Analytics

This document describes best practices and styles for using Google Analytics.

## Tracking Events

Use a spreadsheet to track all events that are tracked in the app.
You can use [this template](https://docs.google.com/spreadsheets/d/1yEgTKGOUVgUlfWrG-qjul5ers80qcINw4UcisZoMSD8/edit?usp=sharing) containing all recommended events.

### Style Guide

- Event names must be in `snake_case` and must start with a letter.
- Parameter names must be in `snake_case`.
- Parameter values can use any format.

Event and Parameter names are case sensitive. For example, `my_event` and `My_Event` are considered different events. Use only letters, numbers, and underscores. Don't use spaces. Do not use reserved names for prefixes, events, parameters and properties. You can see the full list of reserved names [here](https://support.google.com/analytics/answer/13316687?hl=en).

### Automatically Collected Events

Some events are automatically collected by the Google Analytics SDK.
These relate to the app's lifecycle, interactions with Google services (notifications, in-app purchases, etc.), and OS-level events (app updates, etc.)
You can see the full list [here](https://support.google.com/analytics/answer/9234069?hl=en).

### Recommended Events

Recommended events are not sent automatically and require a manual implementation. These should use the predefined names and parameters to get the most out of Google's current and future reporting capabilities, features and integrations. See some relevant examples below:

| Event Name | Parameters | Description |
| ---------- | ---------- | ----------- |
| `login` | `method` | The user logs in. |
| `sign_up` | `method` | The user signs up. |
| `share` | `content_type`, `item_id` | The user shares content. |
| `search` | `search_term` | The user searches for content. |
| `screen_view` | `firebase_screen`, `firebase_screen_class` | The user views a screen. |
| `campaign_details` | `source`, `medium`, `campaign` | The user opens the app with a link containing UTM parameters. |

You can see the full list of pre-defined GA events [here](https://support.google.com/analytics/answer/9267735?hl=en).

### Custom Events

Before you create a custom event, make sure the event you want to create isn't already collected through an automatically collected event or recommended as a recommended event. It's always better to use an existing event because these events automatically populate dimensions and metrics that are used in your reports.

The Event Name should describe what you intend to measure with the event. For example, if you're measuring donations, the name might be "donate".

The Event Parameters should provide more information about the action that took place.

Before creating a new parameter, make sure there is no existing option that can match the information you want to send. Some parameters already populate [existing dimensions and metrics](https://support.google.com/analytics/answer/9143382) from Google Analytics. If you need to create a new parameter, you must also create a [custom dimension or metric](https://support.google.com/analytics/answer/10075209?) in order to access the data in the reports. For example, if you set up a 'cat_type' event parameter, you should create a custom metric called 'Cat Type' which allows you to see each value assigned to the event parameter.

As a best practice, prefer multiple events with fewer parameters over fewer events with more parameters. This makes it easier to analyze the data in your reports and requires less custom dimensions.

The following list contains custom events that can be useful in most apps:

| Event Name | Parameters | Description |
| ---------- | ---------- | ----------- |
| `app_open` | | The app is opened. |
| `delete_account` | | The user deletes their account. |
| `logout` | | The user logs out. |
| `url_view` | `url` | The user views a URL. |

You can see more information about custom events [here](https://support.google.com/analytics/answer/12229021?hl=en).

### Screen Views

Screen views should be tracked using the `screen_view` event. The `firebase_screen` parameter should be set to the name of the screen. The `firebase_screen_class` parameter should be set to the name of the screen class.

- `firebase_screen` is a string that represents the resolved URL of the screen, without placeholders. For example, if the route path is `/home/items/:id`, the value should be `home/items/123`.
- `firebase_screen_class` is a string that represents the name of the first widget created for the route. For example `ItemDetailPage`.

### Campaigns

Campaigns are used to track the source of a user's acquisition. For example, if a user clicks on a deeplink or a push notification, the campaign parameters (also known as UTM parameters) will be added to the link. When the user opens the app, the campaign parameters should be sent to Google Analytics.

- Use the `campaign_details` event to track the campaign.
- `source` is the referrer of the campaign. For example, `substack`.
- `medium` is the delivery medium of the campaign. For example, `email`.
- `campaign` is the name of the campaign. For example, `summer_sale`.
- Use the `app_open` event after the `campaign_details` event to mark the campaign as source of the user's engagement.

All parameters are optional. You can see more information about campaigns [here](https://support.google.com/analytics/answer/11242841?hl=en).

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
- Event-scoped custom dimensions are capped at 50.
- User property Names must be 24 characters or less.
- User property Values must be 36 characters or less.
- User-scoped custom dimensions are capped at 25.

You can see the full list of limits [here](https://support.google.com/analytics/answer/9267744?hl=en).

## Asking the User for Permission

Analytics must be disabled by default, and opted in to comply with GDPR.
The user should be asked for permission to collect analytics data when they register/login or open the app.

If the events are also used for tracking purposes (ie: facebook ads), the user must also opt-in to tracking before collecting any data.

When permission is granted, we can send the `user_id` property to Google Analytics. This allows us to view events for that user in a linear sequence, and to see the user's path through the app.
After the user logs out, the `user_id` should be cleared.

## Visualizing Data

Data can be visualized using the Google Analytics dashboard. However, the dashboard can be cumbersome to use. It's recommended to use Looker Studio to create custom dashboards and reports.

### Path Exploration

The path exploration report can be used to visualize the paths users take through the app. This can be used to identify the most common paths, and the paths that lead to the most conversions.

You can see more information about path exploration [here](https://support.google.com/analytics/answer/9317498?hl=en).
