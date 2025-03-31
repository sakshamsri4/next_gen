# Auth Module Cursor Prompts (Brick-Friendly)

## Overview

These prompts are designed to be brick-friendly, allowing for easy extraction into a Mason brick later. They follow the very_good_core architecture with feature-first organization.

## Brick-Ready Adjustments to Prompts

Every file, bloc, and model must:
- Avoid hardcoded strings like NextGen or LoginBloc in ways that aren't parameterizable.
- Group related files under auth/ feature folder (lib/features/auth/...).
- Follow the structure below:

```
lib/
  features/
    auth/
      bloc/
      models/
      repository/
      view/
      widgets/
```

## Prompt 1 – Create Brickable Folder Structure

Create a new folder `lib/features/auth/` with subfolders:
- bloc/
- models/
- repository/
- view/
- widgets/
Follow the very_good_core + feature-first architecture.

## Prompt 2 – Freezed User Model

Inside `lib/features/auth/models/user.dart`, create a Freezed class `AppUser` with:

- String id
- String email
- String? name
- String? photoUrl
- String role ("employee" or "customer")

Add `fromJson`, `toJson` methods.

## Prompt 3 – Auth Repository Interface & Impl

Inside `lib/features/auth/repository/`, create:

1. `auth_repository.dart` with:
- Future<AppUser?> signInWithEmail(String email, String password)
- Future<AppUser?> signUpWithEmail(String name, String email, String password, String role)
- Future<AppUser?> signInWithGoogle()
- Future<void> signOut()
- Future<AppUser?> getCurrentUser()

2. `auth_repository_impl.dart`: Implements above using FirebaseAuth + Firestore. Save `AppUser` to `users/{uid}` in Firestore after sign up.

## Prompt 4 – Auth Cubit with HydratedBloc

In `auth/bloc/auth_cubit.dart`, create an `AuthCubit` that:

- Extends `HydratedCubit<AuthState>`
- Emits:
  - AuthState.unauthenticated()
  - AuthState.authenticated(AppUser user)
  - AuthState.unknown()

- Uses AuthRepository
- Implements `fromJson` and `toJson` to persist state

Use Freezed for `AuthState`.

## Prompt 5 – LoginBloc & SignupBloc with Freezed

Create `LoginBloc` and `SignupBloc` using Freezed.

LoginBloc (login_bloc.dart):
- Events: emailChanged, passwordChanged, submitted, googleSignInPressed
- States: initial, submitting, success, failure(String error)

SignupBloc (signup_bloc.dart):
- Events: nameChanged, emailChanged, passwordChanged, roleChanged, submitted
- States: same as LoginBloc

Place inside `lib/features/auth/bloc/`.

## Prompt 6 – LoginPage UI (Brick-Extractable)

Create `login_page.dart` inside `auth/view/`.

- Use BlocBuilder<LoginBloc, LoginState>
- Form: email, password, "remember me" checkbox
- Buttons: Login, Google Sign-In (with icon)
- Links: "Forgot password", "Don't have an account? Sign up"

Use reusable widgets in `auth/widgets/` for:
- AuthTextField
- AuthButton

## Prompt 7 – SignupPage UI (Also Brick-Extractable)

Create `signup_page.dart` in `auth/view/`.

- Form: name, email, password, role dropdown
- BlocBuilder<SignupBloc, SignupState>
- On success → navigate to /home
- Link to login

Use the same shared widgets (text fields/buttons) from `auth/widgets/`.

## Prompt 8 – Auth Wrapper

Create `auth_wrapper.dart` in `auth/view/`.

This widget:
- Uses BlocBuilder<AuthCubit, AuthState>
- If Authenticated → go to `/home`
- If Unauthenticated → `/login`
- If Unknown → show CircularProgressIndicator

## Prompt 9 – go_router Setup

In `lib/app/router/app_router.dart`, setup go_router like this:

- `/login` → LoginPage
- `/signup` → SignupPage
- `/home` → Placeholder HomePage
- `AuthCubit` provides redirect logic based on state

Use GoRouter 13+. Hook this into the main app widget.

## Prompt 10 – Testing (Optional but Brickable)

Create `auth/bloc/login_bloc_test.dart`.

Use `bloc_test` to test:
- Email/password change
- Submit success
- Submit failure

Mock AuthRepository using Mockito or Fake class.

## Prompt 11 – Brickify Auth Module (After Stable)

Once the entire Auth module is working:

Make a Mason brick called `auth_feature`.

It should:
- Scaffold full folder structure under `features/auth`
- Include blocs, Freezed models, auth pages
- Accept brick variables like `app_name`, `role_options`, `google_sign_in_enabled`

Save it in `/bricks/auth_feature/` 