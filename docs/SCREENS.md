# Screens

This documents lists all the available screens in the app with the following information:

- **Description**: a brief description of the screen's functionality.
- **Path**: used for Deeplinks, In-App navigation and Analytics (displayed as "screen name").
- **Name**: displayed in Analytics as "screen class".
- **Parameters (optional)**: a list of query parameters that can be passed to the screen.

## Login

Displays a set of methods for users to authenticate using their email and password.

- Path: `/login`.
- Name: `LoginPage`.

## Bottom Tabs

### Articles

Displays a list of articles.

- Path: `/articles`.
- Name: `ArticlesPage`.

#### Article Detail

Displays a webview with the contents of the article.

- Path: `/articles/:aid`.
- Name: `ArticleDetailPage`.

### Blank

A blank page for testing.

- Path: `/blank`.
- Name: `BlankPage`.

#### Article Detail Blank

Displays a random article for testing.

- Path: `/blank/:aid`.
- Name: `ArticleDetailBlankPage`.
