import axios, {AxiosInstance} from "axios";
import {WikiDataEntityDetails, WikiDataResponse, WikiDataSearchApiResponse} from "./types.ts";

class WikiDataService {
  private api: AxiosInstance;

  constructor() {
    this.api = axios.create({
      baseURL: 'https://www.wikidata.org/w/api.php',
    });
  }

  /**
   * Fetch metadata about a WikiData item by its ID.
   * @param itemId - The WikiData item ID (e.g., Q42 for Douglas Adams).
   * @param languages - Array of languages for labels/descriptions.
   * @returns Metadata object.
   */
  async getItemMetaInfo(
    itemId: string,
    languages: string[] = ['en']
  ): Promise<WikiDataEntityDetails | null> {
    try {
      const response = await this.api.get<WikiDataResponse>('', {
        params: {
          action: 'wbgetentities',
          ids: itemId,
          format: 'json',
          props: 'labels|descriptions|claims',
        },
      });

      const entity = response.data.entities[itemId];
      if (!entity) {
        throw new Error(`Item with ID ${itemId} not found`);
      }

      const filteredLabels = Object.fromEntries(
        Object.entries(entity.labels).filter(([lang]) => languages.includes(lang))
      );
      const filteredDescriptions = Object.fromEntries(
        Object.entries(entity.descriptions).filter(([lang]) => languages.includes(lang))
      );

      return {
        ...entity,
        labels: filteredLabels,
        descriptions: filteredDescriptions,
      };
    } catch (error) {
      console.error(`Failed to fetch data for item ${itemId}:`, error);
      return null;
    }
  }

  /**
   * Query WikiData API for search results.
   * @param search - The search query string.
   * @param language - The language to use for the search.
   * @param limit - The number of results to return.
   * @returns A promise resolving to the search results.
   */
  async queryWikidata({
                        search = '',
                        language = 'en',
                        limit = 12,
                        action = 'wbsearchentities',
                        uselang = 'en',
                        type = '',
                        format = 'json',
                        formatversion = 2,
                        errorformat = 'plaintext',
                        origin = '*',
                      }: {
    search: string;
    language?: string;
    limit?: number;
    action?: string;
    uselang?: string;
    type?: string;
    format?: string;
    formatversion?: number;
    errorformat?: string;
    origin?: string;
  }): Promise<WikiDataSearchApiResponse> {
    if (!search) {
      return Promise.resolve({
        search: [],
        errors: [],
        success: 0,
        searchinfo: {},
      });
    }

    const params = {
      action,
      search,
      language,
      uselang,
      type,
      format,
      formatversion,
      errorformat,
      origin,
      limit,
    };

    try {
      const response = await this.api.get<WikiDataSearchApiResponse>('', { params });
      return response.data;
    } catch (error) {
      console.error('Error while querying the WikiData API:', error);
      return {
        search: [],
        errors: [],
        success: 0,
        searchinfo: {},
      };
    }
  }
}

export default WikiDataService;
