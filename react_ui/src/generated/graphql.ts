/* eslint-disable */
// This file was automatically generated and should not be edited.
// --
import gql from 'graphql-tag';
import * as ApolloReactCommon from '@apollo/client';
import * as ApolloReactHooks from '@apollo/client';
export type Maybe<T> = T | null;
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: string;
  String: string;
  Boolean: boolean;
  Int: number;
  Float: number;
};

export type Address = {
  readonly __typename?: 'Address';
  readonly city: Maybe<Scalars['String']>;
  readonly countryCode: Scalars['String'];
  readonly id: Scalars['ID'];
  readonly label: Maybe<Scalars['String']>;
  readonly postalCode: Scalars['String'];
  readonly province: Scalars['String'];
  readonly street: Maybe<Scalars['String']>;
};

export type AddressInput = {
  readonly countryCode: Maybe<Scalars['String']>;
  readonly postalCode: Maybe<Scalars['String']>;
  readonly province: Maybe<Scalars['String']>;
};

export type Group = {
  readonly __typename?: 'Group';
  readonly description: Maybe<Scalars['String']>;
  readonly donationForm: Maybe<Scalars['String']>;
  readonly donationFormResults: Maybe<Scalars['String']>;
  readonly donationLink: Maybe<Scalars['String']>;
  readonly id: Scalars['ID'];
  readonly leader: Maybe<Scalars['String']>;
  readonly location: Address;
  readonly name: Scalars['String'];
  readonly requestForm: Maybe<Scalars['String']>;
  readonly requestFormResults: Maybe<Scalars['String']>;
  readonly slackChannelName: Maybe<Scalars['String']>;
  readonly slug: Scalars['String'];
  readonly type: GroupType;
  readonly volunteerForm: Maybe<Scalars['String']>;
  readonly volunteerFormResults: Maybe<Scalars['String']>;
};

export type GroupInput = {
  readonly description: Maybe<Scalars['String']>;
  readonly donationForm: Maybe<Scalars['String']>;
  readonly donationFormResults: Maybe<Scalars['String']>;
  readonly donationLink: Maybe<Scalars['String']>;
  readonly leader: Maybe<Scalars['String']>;
  readonly location: Maybe<AddressInput>;
  readonly name: Maybe<Scalars['String']>;
  readonly requestForm: Maybe<Scalars['String']>;
  readonly requestFormResults: Maybe<Scalars['String']>;
  readonly slackChannelName: Maybe<Scalars['String']>;
  readonly slug: Maybe<Scalars['String']>;
  readonly volunteerForm: Maybe<Scalars['String']>;
  readonly volunteerFormResults: Maybe<Scalars['String']>;
};

export type GroupPayload = {
  readonly __typename?: 'GroupPayload';
  readonly messages: Maybe<ReadonlyArray<Maybe<ValidationMessage>>>;
  readonly result: Maybe<Group>;
  readonly successful: Scalars['Boolean'];
};

export enum GroupType {
  M4D_CHAPTER = 'M4D_CHAPTER'
}

export type RootMutationType = {
  readonly __typename?: 'RootMutationType';
  readonly createGroup: Maybe<GroupPayload>;
  readonly deleteGroup: Maybe<Group>;
  readonly updateGroup: Maybe<GroupPayload>;
};


export type RootMutationTypeCreateGroupArgs = {
  groupInput: GroupInput;
};


export type RootMutationTypeDeleteGroupArgs = {
  id: Scalars['ID'];
};


export type RootMutationTypeUpdateGroupArgs = {
  groupInput: GroupInput;
  id: Scalars['ID'];
};

export type RootQueryType = {
  readonly __typename?: 'RootQueryType';
  readonly countGroups: Maybe<Scalars['Int']>;
  readonly group: Maybe<Group>;
  readonly groupBySlug: Maybe<Group>;
  readonly groups: Maybe<ReadonlyArray<Maybe<Group>>>;
  readonly healthCheck: Maybe<Scalars['String']>;
  readonly session: Maybe<Session>;
};


export type RootQueryTypeGroupArgs = {
  id: Scalars['ID'];
};


export type RootQueryTypeGroupBySlugArgs = {
  slug: Scalars['String'];
};

export type Session = {
  readonly __typename?: 'Session';
  readonly id: Maybe<Scalars['ID']>;
  readonly userId: Maybe<Scalars['ID']>;
};

export type ValidationMessage = {
  readonly __typename?: 'ValidationMessage';
  readonly code: Scalars['String'];
  readonly field: Maybe<Scalars['String']>;
  readonly message: Maybe<Scalars['String']>;
  readonly options: Maybe<ReadonlyArray<Maybe<ValidationOption>>>;
  readonly template: Maybe<Scalars['String']>;
};

export type ValidationOption = {
  readonly __typename?: 'ValidationOption';
  readonly key: Scalars['String'];
  readonly value: Scalars['String'];
};

export type CreateChapterMutationVariables = {
  groupInput: GroupInput;
};


export type CreateChapterMutation = { readonly __typename?: 'RootMutationType', readonly createGroup: Maybe<{ readonly __typename?: 'GroupPayload', readonly successful: boolean, readonly result: Maybe<{ readonly __typename?: 'Group', readonly id: string, readonly slug: string }>, readonly messages: Maybe<ReadonlyArray<Maybe<{ readonly __typename?: 'ValidationMessage', readonly field: Maybe<string>, readonly message: Maybe<string> }>>> }> };

export type GetChapterBySlugQueryVariables = {
  slug: Scalars['String'];
};


export type GetChapterBySlugQuery = { readonly __typename?: 'RootQueryType', readonly groupBySlug: Maybe<{ readonly __typename: 'Group', readonly id: string, readonly name: string, readonly slug: string, readonly leader: Maybe<string>, readonly description: Maybe<string>, readonly donationForm: Maybe<string>, readonly donationLink: Maybe<string>, readonly donationFormResults: Maybe<string>, readonly slackChannelName: Maybe<string>, readonly volunteerForm: Maybe<string>, readonly volunteerFormResults: Maybe<string>, readonly requestForm: Maybe<string>, readonly requestFormResults: Maybe<string>, readonly location: { readonly __typename?: 'Address', readonly countryCode: string, readonly province: string, readonly postalCode: string } }> };

export type GetChapterListQueryVariables = {};


export type GetChapterListQuery = { readonly __typename?: 'RootQueryType', readonly groups: Maybe<ReadonlyArray<Maybe<{ readonly __typename: 'Group', readonly id: string, readonly slug: string, readonly description: Maybe<string>, readonly name: string, readonly location: { readonly __typename?: 'Address', readonly id: string, readonly province: string, readonly countryCode: string } }>>> };

export type UpdateChapterMutationVariables = {
  id: Scalars['ID'];
  groupInput: GroupInput;
};


export type UpdateChapterMutation = { readonly __typename?: 'RootMutationType', readonly updateGroup: Maybe<{ readonly __typename?: 'GroupPayload', readonly successful: boolean, readonly result: Maybe<{ readonly __typename: 'Group', readonly id: string, readonly slug: string }>, readonly messages: Maybe<ReadonlyArray<Maybe<{ readonly __typename?: 'ValidationMessage', readonly field: Maybe<string>, readonly message: Maybe<string> }>>> }> };


export const CreateChapterDocument = gql`
    mutation createChapter($groupInput: GroupInput!) {
  createGroup(groupInput: $groupInput) {
    successful
    result {
      id
      slug
    }
    messages {
      field
      message
    }
  }
}
    `;
export type CreateChapterMutationFn = ApolloReactCommon.MutationFunction<CreateChapterMutation, CreateChapterMutationVariables>;

/**
 * __useCreateChapterMutation__
 *
 * To run a mutation, you first call `useCreateChapterMutation` within a React component and pass it any options that fit your needs.
 * When your component renders, `useCreateChapterMutation` returns a tuple that includes:
 * - A mutate function that you can call at any time to execute the mutation
 * - An object with fields that represent the current status of the mutation's execution
 *
 * @param baseOptions options that will be passed into the mutation, supported options are listed on: https://www.apollographql.com/docs/react/api/react-hooks/#options-2;
 *
 * @example
 * const [createChapterMutation, { data, loading, error }] = useCreateChapterMutation({
 *   variables: {
 *      groupInput: // value for 'groupInput'
 *   },
 * });
 */
export function useCreateChapterMutation(baseOptions?: ApolloReactHooks.MutationHookOptions<CreateChapterMutation, CreateChapterMutationVariables>) {
        return ApolloReactHooks.useMutation<CreateChapterMutation, CreateChapterMutationVariables>(CreateChapterDocument, baseOptions);
      }
export type CreateChapterMutationHookResult = ReturnType<typeof useCreateChapterMutation>;
export type CreateChapterMutationResult = ApolloReactCommon.MutationResult<CreateChapterMutation>;
export type CreateChapterMutationOptions = ApolloReactCommon.BaseMutationOptions<CreateChapterMutation, CreateChapterMutationVariables>;
export const GetChapterBySlugDocument = gql`
    query getChapterBySlug($slug: String!) {
  groupBySlug(slug: $slug) {
    id
    __typename
    name
    slug
    leader
    description
    donationForm
    donationLink
    donationFormResults
    location {
      countryCode
      province
      postalCode
    }
    slackChannelName
    volunteerForm
    volunteerFormResults
    requestForm
    requestFormResults
  }
}
    `;

/**
 * __useGetChapterBySlugQuery__
 *
 * To run a query within a React component, call `useGetChapterBySlugQuery` and pass it any options that fit your needs.
 * When your component renders, `useGetChapterBySlugQuery` returns an object from Apollo Client that contains loading, error, and data properties 
 * you can use to render your UI.
 *
 * @param baseOptions options that will be passed into the query, supported options are listed on: https://www.apollographql.com/docs/react/api/react-hooks/#options;
 *
 * @example
 * const { data, loading, error } = useGetChapterBySlugQuery({
 *   variables: {
 *      slug: // value for 'slug'
 *   },
 * });
 */
export function useGetChapterBySlugQuery(baseOptions?: ApolloReactHooks.QueryHookOptions<GetChapterBySlugQuery, GetChapterBySlugQueryVariables>) {
        return ApolloReactHooks.useQuery<GetChapterBySlugQuery, GetChapterBySlugQueryVariables>(GetChapterBySlugDocument, baseOptions);
      }
export function useGetChapterBySlugLazyQuery(baseOptions?: ApolloReactHooks.LazyQueryHookOptions<GetChapterBySlugQuery, GetChapterBySlugQueryVariables>) {
          return ApolloReactHooks.useLazyQuery<GetChapterBySlugQuery, GetChapterBySlugQueryVariables>(GetChapterBySlugDocument, baseOptions);
        }
export type GetChapterBySlugQueryHookResult = ReturnType<typeof useGetChapterBySlugQuery>;
export type GetChapterBySlugLazyQueryHookResult = ReturnType<typeof useGetChapterBySlugLazyQuery>;
export type GetChapterBySlugQueryResult = ApolloReactCommon.QueryResult<GetChapterBySlugQuery, GetChapterBySlugQueryVariables>;
export const GetChapterListDocument = gql`
    query getChapterList {
  groups {
    id
    __typename
    slug
    description
    name
    location {
      id
      province
      countryCode
    }
  }
}
    `;

/**
 * __useGetChapterListQuery__
 *
 * To run a query within a React component, call `useGetChapterListQuery` and pass it any options that fit your needs.
 * When your component renders, `useGetChapterListQuery` returns an object from Apollo Client that contains loading, error, and data properties 
 * you can use to render your UI.
 *
 * @param baseOptions options that will be passed into the query, supported options are listed on: https://www.apollographql.com/docs/react/api/react-hooks/#options;
 *
 * @example
 * const { data, loading, error } = useGetChapterListQuery({
 *   variables: {
 *   },
 * });
 */
export function useGetChapterListQuery(baseOptions?: ApolloReactHooks.QueryHookOptions<GetChapterListQuery, GetChapterListQueryVariables>) {
        return ApolloReactHooks.useQuery<GetChapterListQuery, GetChapterListQueryVariables>(GetChapterListDocument, baseOptions);
      }
export function useGetChapterListLazyQuery(baseOptions?: ApolloReactHooks.LazyQueryHookOptions<GetChapterListQuery, GetChapterListQueryVariables>) {
          return ApolloReactHooks.useLazyQuery<GetChapterListQuery, GetChapterListQueryVariables>(GetChapterListDocument, baseOptions);
        }
export type GetChapterListQueryHookResult = ReturnType<typeof useGetChapterListQuery>;
export type GetChapterListLazyQueryHookResult = ReturnType<typeof useGetChapterListLazyQuery>;
export type GetChapterListQueryResult = ApolloReactCommon.QueryResult<GetChapterListQuery, GetChapterListQueryVariables>;
export const UpdateChapterDocument = gql`
    mutation updateChapter($id: ID!, $groupInput: GroupInput!) {
  updateGroup(id: $id, groupInput: $groupInput) {
    successful
    result {
      id
      __typename
      slug
    }
    messages {
      field
      message
    }
  }
}
    `;
export type UpdateChapterMutationFn = ApolloReactCommon.MutationFunction<UpdateChapterMutation, UpdateChapterMutationVariables>;

/**
 * __useUpdateChapterMutation__
 *
 * To run a mutation, you first call `useUpdateChapterMutation` within a React component and pass it any options that fit your needs.
 * When your component renders, `useUpdateChapterMutation` returns a tuple that includes:
 * - A mutate function that you can call at any time to execute the mutation
 * - An object with fields that represent the current status of the mutation's execution
 *
 * @param baseOptions options that will be passed into the mutation, supported options are listed on: https://www.apollographql.com/docs/react/api/react-hooks/#options-2;
 *
 * @example
 * const [updateChapterMutation, { data, loading, error }] = useUpdateChapterMutation({
 *   variables: {
 *      id: // value for 'id'
 *      groupInput: // value for 'groupInput'
 *   },
 * });
 */
export function useUpdateChapterMutation(baseOptions?: ApolloReactHooks.MutationHookOptions<UpdateChapterMutation, UpdateChapterMutationVariables>) {
        return ApolloReactHooks.useMutation<UpdateChapterMutation, UpdateChapterMutationVariables>(UpdateChapterDocument, baseOptions);
      }
export type UpdateChapterMutationHookResult = ReturnType<typeof useUpdateChapterMutation>;
export type UpdateChapterMutationResult = ApolloReactCommon.MutationResult<UpdateChapterMutation>;
export type UpdateChapterMutationOptions = ApolloReactCommon.BaseMutationOptions<UpdateChapterMutation, UpdateChapterMutationVariables>;


