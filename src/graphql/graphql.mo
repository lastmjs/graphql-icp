// TODO get rid of all any types...figure out union types, that's the source of the any problems

// import Dict = "mo:stdlib/dict"; // TODO this does not seem supported yet in the version of the sdk available to me.
// TODO I think we need to use a dictionary to dynamically set a property

type Document = {
    kind: Text; // TODO It would be nice to have explicit strings as types, such as "Document" here instead of just Text
    definitions: [
        {
            #objectTypeDefinition: ObjectTypeDefinition;
            #operationDefinition: OperationDefinition;
        }
    ];
};

type OperationDefinition = {
    kind: Text;
    operation: Text;
    selectionSet: SelectionSet;
};

type SelectionSet = {
    kind: Text;
    selections: [Field];
};

type Field = {
    kind: Text;
    name: Name;
    selectionSet: SelectionSet;
};

type ObjectTypeDefinition = {
    kind: Text;
    name: Name;
    fields: [FieldDefinition];
};

type Name = {
    kind: Text;
    value: Text;
};

type FieldDefinition = {
    kind: Text;
    name: Name;
    gqlType: {
        #nonNullType: NonNullType;
        #namedType: NamedType;
    };
};

type NonNullType = {
    kind: Text;
    gqlType: NamedType;
};

type NamedType = {
    kind: Text;
    name: Name;
};

actor {
    // TODO We need to know how to return arbitrary data...we should probably just return a string that is in JSON format
    // TODO is there a JSON type?
    public func gql(/* queryString: Text */): async Text {

        let resolvers = {
            note = {
                id = func (): Nat {
                    return 5;
                };
                body = func (): Text {
                    return "Buy some groceries";
                };
            };
        };

        let schema: Text = "type Note { id: Int! }";
        let schemaDocument: Document = {
            kind = "Document";
            definitions = [
                #objectTypeDefinition {
                    kind = "ObjectTypeDefinition";
                    name = {
                        kind = "Name";
                        value = "id";
                    };
                    fields = [
                        {
                            kind = "FieldDefinition";
                            name = {
                                kind = "Name";
                                value = "id";
                            };
                            gqlType = #nonNullType {
                                kind = "NonNullType";
                                gqlType = {
                                    kind = "NamedType";
                                    name = {
                                        kind = "Name";
                                        value = "Int";
                                    };
                                };
                            };
                        }
                    ];
                }
            ];
        };

        let queryString: Text = "query { note { id } }";
        let queryDocument: Document = {
            kind = "Document";
            definitions = [
                #operationDefinition {
                    kind = "OperationDefinition";
                    operation = "query";
                    selectionSet = {
                        kind = "SelectionSet";
                        selections = [
                            {
                                kind = "Field";
                                name = {
                                    kind = "Name";
                                    value = "note";
                                };
                                selectionSet = {
                                    kind = "SelectionSet";
                                    selections = [
                                        {
                                            kind = "Field";
                                            name = {
                                                kind = "Name";
                                                value = "id";
                                            };
                                            selectionSet = { // TODO I might want this to be null instead...but perhaps an empty selection set is good
                                                kind = "SelectionSet";
                                                selections = [];
                                            };
                                        }
                                    ];
                                };
                            }
                        ];
                    };
                }
            ];
        };

        // let unionList: [{ #nat: Nat; #text: Text }] = [#nat 0];
        // let unionListMember: Nat = {
        //     let (#nat n) = unionList[0];
        //     n;
        // };

        // let temp: Nat = #nat unionListMember;

        // type name = {#bob; #susy};

        // let temp: name = "bob";

        // TODO I am having trouble explicitly typing this with #operationDefinition...gives a syntax error for some reason
        // let queryOperationDefinition: OperationDefinition = queryDocument.definitions[0] #operationDefinition;

        // let temp: OperationDefinition = #operationDefinition queryOperationDefinition;
        // let id: Nat = resolvers.note.id();
        // let body: Text = resolvers.note.body();
        // let note = resolvers.note;
        // let result = note.body();

        // TODO use the query document to resolve the data

        // test();

        let topLevelSelectionSet: SelectionSet = {
            let (#operationDefinition queryOperationDefinition) = queryDocument.definitions[0];
            queryOperationDefinition.selectionSet;
        };

        let result: {} = resolveOperation(topLevelSelectionSet, {});

        return objectToJSON(result);
        // return "";
    };

    // TODO we might have to use dictionaries for all of the dynamic stuff
    func resolveOperation(selectionSet: SelectionSet, result: {}): {} {        
        if (selectionSet.selections.len() == 0) {
            return result;
        };

        // let hello = "hello";

        // let temp = {};

        // temp[hello] = 5;

        // TODO make sure bounds and everything are handled correctly here...
        // TODO switch to a functional way of doing this
        // var tempResult = {};

        // for (selection in range(0, selectionSet.selections.len())) {
            // tempResult[selection.name.value] = {};
        // };
        
        return {
            two = 2;
        };
    };

    // TODO we might need to use a dictionary for this
    // TODO it would be nice if we could turn a dictionary into an object
    func objectToJSON(source: {}): Text {
        return "{ \"works\": true }";
    }



            // let schema: Text = "
        //     type User {
        //         id: Int!;
        //     }
        // ";
        
        // let resolvers = {
        //     User = () => {
        //         id = () => {
        //             return 0;
        //         };
        //     };
        // };
        
        // const document = await parse(query);

        // document.definitions.reduce((result, definition) => {

        //     const result = resolvers[definition.name.value]();

        //     return {
        //         ...result,
        //         []
        //     };

        // }, {});

        // return query;

    // public func parse(source: Text): async Document {
    //     return "It works!";
    // };

    // this will tokenize
    // public func lex(source: Text): async Document {

    // };

    // TODO we will need a way to easily serialize objects to JSON
    // public func objectToJSON(source: object): Text {}
};