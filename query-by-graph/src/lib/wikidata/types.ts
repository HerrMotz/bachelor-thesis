export type WikiDataEntity = {
  id: string;
  title: string;
  pageid: number;
  datatype: string;
  concepturi: string;
  repository: string;
  url: string;
  display: {
    label: {
      value: string;
      language: string;
    };
    description: {
      value: string;
      language: string;
    };
  };
  label: string;
  description: string;
  match: {
    type: string;
    language: string;
    text: string;
  };
  aliases?: string[];
};

export type WikiDataSearchApiResponse = {
  errors: string[];
  searchinfo: object;
  search: WikiDataEntity[];
  success: number;
};

export interface WikiDataLabel {
  language: string;
  value: string;
}

export interface WikiDataDescription {
  language: string;
  value: string;
}

export interface WikiDataEntityDetails {
  id: string;
  labels: { [language: string]: WikiDataLabel };
  descriptions: { [language: string]: WikiDataDescription };
  claims: { [key: string]: any[] };
}

export interface WikiDataResponse {
  entities: { [key: string]: WikiDataEntityDetails };
}

