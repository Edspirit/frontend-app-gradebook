const REACT_QUERY_CONSTANTS = {
  queries: {
    // Set staleTime to 5 minutes
    staleTime: 5 * 60 * 1000,
    // Set cacheTime to 60 minutes
    cacheTime: 60 * 60 * 1000,
    // Set the retry count for queries here
    retry: 1, // Set the retry count for queries here
  },
  mutations: {
    retry: 1, // Set the retry count for mutations here
  },
};

export default REACT_QUERY_CONSTANTS;
