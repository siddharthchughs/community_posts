part of 'post_form_bloc.dart';

typedef PostFormState = SealedAuthStates<Failure, void>;
typedef PostFormIntial = LoadInitialState<Failure, void>;
typedef PostFormProgress = LoadProgressState<Failure, void>;
typedef PostFormSuccess = LoadSuccessState<Failure, void>;
typedef PostFormFailure = LoadFailureState<Failure, void>;
