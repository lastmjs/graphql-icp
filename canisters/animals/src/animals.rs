use ic_cdk_macros::query;
use ic_cdk_macros::update;
use juniper::{
    FieldResult,
    Variables,
    graphql_value
};
use ic_cdk::storage;
use std::collections::BTreeMap;

type CounterStore = BTreeMap<String, i32>;

#[derive(juniper::GraphQLObject)]
struct Animal {
    id: String,
    species: String
}

struct Context {}

impl juniper::Context for Context {}

struct Query;

#[juniper::object(Context = Context)]
impl Query {
    fn getAnimal(context: &Context) -> FieldResult<Animal> {
        return Ok(Animal {
            id: String::from("0"),
            species: String::from("Monkey")
        });
    }

    fn getCounter(context: &Context) -> FieldResult<i32> {
        let counter_store: &BTreeMap<String, i32> = storage::get::<CounterStore>();
        let counter: Option<&i32> = counter_store.get("counter");

        match counter {
            Some(counter) => {
                return Ok(*counter);
            },
            None => {
                return Ok(-1);
            }
        }
    }
}

struct Mutation;

#[juniper::object(Context = Context)]
impl Mutation {
    fn updateCounter() -> FieldResult<i32> {
        let counter_store: &mut BTreeMap<String, i32> = storage::get_mut::<CounterStore>();
        let counter: Option<&i32> = counter_store.get("counter");

        match counter {
            Some(counter) => {
                let new_counter: i32 = counter + 1;
                counter_store.insert(String::from("counter"), new_counter);
                return Ok(new_counter);
            },
            None => {
                counter_store.insert(String::from("counter"), 0);
                return Ok(0);
            }
        }
    }
}

type Schema = juniper::RootNode<'static, Query, Mutation>;

#[update]
fn graphql(query: String) -> String {

    let schema = Schema::new(Query, Mutation);

    let result = juniper::execute(
        &query,
        None,
        &schema,
        &Variables::new(),
        &Context {}
    ).expect("GraphQL execution failed");

    let data = result.0;
    let errors = result.1;

    let normalized_result = graphql_value!({
        "data": data
        // "errors" errors
    });

    return serde_json::to_string(&normalized_result).expect("Could not serialize GraphQL result");
}