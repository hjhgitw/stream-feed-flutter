/// returns a new collection reference string in the form SO:<collection>:<id>.
String createCollectionReference(String? collection, String? id) =>
    'SO:$collection:$id';

///returns a new user reference string in the form SU:<id>.
String createUserReference(String id) => 'SU:$id';

/// returns a new collection reference string in the form SA:<id>.
String createActivityReference(String id) => 'SA:$id';
