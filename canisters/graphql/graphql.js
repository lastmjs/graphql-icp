export default ({ IDL }) => {
 const actor_anon = new IDL.ActorInterface({
  'gql': IDL.Func(IDL.Obj({}), IDL.Obj({'0': IDL.Text}))});
 return actor_anon;
};
