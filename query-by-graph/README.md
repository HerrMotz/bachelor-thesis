# Query by Graph (QuebyG) Front-End

## Tech Stack / Developer notes

This project uses Vue 3 and TypeScript in Vite. Learn more
about the recommended Project Setup and IDE Support in the
[Vue Docs TypeScript Guide](https://vuejs.org/guide/typescript/overview.html#project-setup).

This application solely runs in the browser. This repository
does not contain a backend. The data fetching can be configured
in the environment files. See [Vite Docs](https://vitejs.dev/guide/env-and-mode)
for more details.

As of now, the application does not come with a backend.
Furthermore, there are no plans/needs to add a backend.

## Installation

To install all dependencies, run the following command:

```bash
npm install
```

## Run Scripts

### Running the Application for Development (hot-reload)

```bash
npm run dev
```

### Building for Production

```bash
npm run build
```

The production files are put into the `dist` folder.

For other scripts see `package.json` file.

## Program description

### Functionality
It allows the user to build simple SPARQL queries using a
visual query builder. The query can then be run
against a SPARQL endpoint.

### Feature List
| Feature                                                         | Description                                     | Implemented |
|-----------------------------------------------------------------|-------------------------------------------------|-------------|
| Tracing connectivity between points in the visual query builder | https://jsplumbtoolkit.com/demonstrations/paths | No          |
| Building SPARQL SELECT queries                                  | with arbitrary properties                       | No          |
| Running SPARQL queries                                          | against a SPARQL endpoint                       | No          |
| Displaying the results of the SPARQL query                      | in a table                                      | No          |
| Saving and loading queries                                      | to and from the local storage                   | No          |
| Exporting the query                                             | as a SPARQL query text                          | No          |

### Graph Legend

- **Node**: ontology individual (Qxxxx)
- **Connection**: property (Pxxxx)

## To-Do

- [x] Drawing labels on the connections
- [ ] Inject custom data into the custom connection component
- [ ] Make the connections selectable and deletable
- [ ] Adding new connections with custom data

