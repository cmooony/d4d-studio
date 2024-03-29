using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Core.Data.Exceptions;
using Core.Data.MapperDelegates;


namespace Core.Data
{
}

namespace Core.Data.MapperDelegates
{
    /// <summary>
    /// For mapping individual records from a single-resultset procedure.
    /// </summary>
    /// <param name="record"></param>
    public delegate void RecordMapper(IRecord record);

	/// <summary>
	/// For mapping individual records from a single resultset procedure to an object instance.
	/// </summary>
	/// <typeparam name="T"></typeparam>
	/// <param name="record"></param>
	/// <param name="objectInstance"></param>
	public delegate void RecordMapper<T>(IRecord record, T objectInstance);

	/// <summary>
	/// For mapping individual records from a multiple resultset procedure to an object instance.
	/// </summary>
	/// <typeparam name="T"></typeparam>
	/// <param name="record"></param>
	/// <param name="objectInstance"></param>
	/// <param name="recordSetIndex"></param>
	public delegate void MrsRecordMapper<T>(IRecord record, int recordSetIndex, T objectInstance);

    /// <summary>
    /// For mapping entire results from single or multi-resultset procedures.
    /// </summary>
    /// <param name="record"></param>
    public delegate void ResultMapper(IRecordSet record);

    /// <summary>
    /// For injecting parameters into a command.
    /// </summary>
    /// <param name="parameters"></param>
    public delegate void ParameterMapper(IParameterSet parameters);

	/// <summary>
	/// For injecting parameters from an object instance into a command.
	/// </summary>
	/// <typeparam name="T"></typeparam>
	/// <param name="parameters"></param>
	/// <param name="objectInstance"></param>
	public delegate void ParameterMapper<T>(IParameterSet parameters, T objectInstance);

    /// <summary>
    /// For populating output parameters
    /// </summary>
	/// <param name="outputParameters"></param>
    public delegate void OutputParameterMapper(IParameterSet outputParameters);

	/// <summary>
	/// For populating output parameters from an object instance - added for unit testing.
	/// </summary>
	/// <typeparam name="T"></typeparam>
	/// <param name="outputParameters"></param>
	/// <param name="objectInstance"></param>
	public delegate void OutputParameterMapper<T>(IParameterSet outputParameters, T objectInstance);
}

namespace Core.Data
{
    /// <summary>
    /// A set of methods that will guarantee safe database connectivity.
    /// </summary>
    public class SafeProcedure
    {
      

		/// <summary>
		/// 	<para>Executes a SQL stored procedure on the specified <see cref="Database"/>.</para>
		/// </summary>
		/// <param name="database">
		/// 	<para>The <see cref="Database"/> on which to execute sproc.
		///		Connections to this database are managed automatically.</para>
		/// </param>
		/// <param name="procedureName">
		/// 	<para>The name of the sproc to execute.</para>
		/// </param>
		/// <param name="parameterMapper">
		/// 	<para>A delegate that will populate the parameters in the sproc call.
		///		Specify <see langword="null"/> if the sproc does not require parameters.</para>
		/// </param>
		/// <param name="outputMapper">
		/// 	<para>A delegate that will read the value of the parameters returned
		///		by the sproc call.  Specify <see langword="null"/> if no output parameters
		///		have been provided by the <paramref name="parameterMapper"/> delegate.</para>
		/// </param>
		/// <returns>
		/// 	<para>An <see cref="Int32"/> value indicating the number of rows 
		///		affected by this sproc call.</para>
		/// </returns>
		/// <exception cref="ArgumentNullException">
		/// 	<para>The argument <paramref name="database"/> is <see langword="null"/>.</para>
		/// 	<para>-or-</para>
		/// 	<para>The argument <paramref name="procedureName"/> is <see langword="null"/>.</para>
		/// </exception>
		/// <exception cref="SafeProcedureException">
		///		<para>An unexpected exception has been encountered during the sproc call.</para>
		/// </exception>
		public static int ExecuteNonQuery(Database database, string procedureName, ParameterMapper parameterMapper, OutputParameterMapper outputMapper)
        {
			if (database == null) throw new ArgumentNullException("database");
			if (procedureName == null) throw new ArgumentNullException("procedureName");

            int result = 0;

            try
            {
                using (SqlConnection connection = database.GetOpenConnection())
                {
					result = ExecuteNonQuery(database, connection, procedureName, parameterMapper, outputMapper);
                }
            }
            catch (SafeProcedureException)
            {
				throw;
            }
            catch (Exception e)
            {
                throw new SafeProcedureException(database, procedureName, e);
            }

            return result;
        }

		/// <summary>
		/// 	<para>Executes a SQL stored procedure on a provided connection.</para>
		/// </summary>
		/// <param name="database">
		/// 	<para>The <see cref="Database"/> to which the specified connection
		/// 	object belongs.  This object is for informational purposes only,
		/// 	and will not be used to create new connections.</para>
		/// </param>
		/// <param name="connection">
		/// 	<para>The <see cref="SqlConnection"/> on which to execute sproc.
		/// 	If this connection is not yet open, it will be opened and closed.  
		/// 	If this connection is already open, it will NOT be closed.  In this case,
		/// 	the caller is responsible for its disposal.</para>
		/// </param>
		/// <param name="procedureName">
		/// 	<para>The name of the sproc to execute.</para>
		/// </param>
		/// <param name="parameterMapper">
		/// 	<para>A delegate that will populate the parameters in the sproc call.
		/// 	Specify <see langword="null"/> if the sproc does not require parameters.</para>
		/// </param>
		/// <param name="outputMapper">
		/// 	<para>A delegate that will read the value of the parameters returned
		/// 	by the sproc call.  Specify <see langword="null"/> if no output parameters
		/// 	have been provided by the <paramref name="parameterMapper"/> delegate.</para>
		/// </param>
		/// <returns>
		/// 	<para>An <see cref="Int32"/> value indicating the number of rows 
		/// 	affected by this sproc call.</para>
		/// </returns>
		/// <exception cref="ArgumentNullException">
		/// 	<para>The argument <paramref name="database"/> is <see langword="null"/>.</para>
		/// 	<para>-or-</para>
		/// 	<para>The argument <paramref name="connection"/> is <see langword="null"/>.</para>
		/// 	<para>-or-</para>
		/// 	<para>The argument <paramref name="procedureName"/> is <see langword="null"/>.</para>
		/// </exception>
		/// <exception cref="SafeProcedureException">
		/// 	<para>An unexpected exception has been encountered during the sproc call.</para>
		/// </exception>
		public static int ExecuteNonQuery(Database database, SqlConnection connection, string procedureName, 
			ParameterMapper parameterMapper, OutputParameterMapper outputMapper)
		{
			if (database == null) throw new ArgumentNullException("database");
			if (connection == null) throw new ArgumentNullException("connection");
			if (procedureName == null) throw new ArgumentNullException("procedureName");

			int result = 0;

			try
			{
				SqlCommand command = CommandFactory.CreateParameterMappedCommand(connection, procedureName, parameterMapper);

		
				bool doClose = false;
				if (connection.State != ConnectionState.Open)
				{
					doClose = true;
					connection.Open();
				}
				result = command.ExecuteNonQuery();
				if (doClose)
				{
					connection.Close();
				}

				if (outputMapper != null)
				{
					ParameterSet outputParams = new ParameterSet(command.Parameters);
					outputMapper(outputParams);
				}
			}
			catch (Exception e)
			{
				throw new SafeProcedureException(database, procedureName, e);
			}

			return result;
		}

        /// <summary>
		/// Executes a query and returns the number of affected rows.
        /// </summary>
        /// <param name="database"></param>
		/// <param name="procedureName"></param>
		/// <param name="parameterMapper"></param>
		/// <returns></returns>
		public static int ExecuteNonQuery(Database database, string procedureName, ParameterMapper parameterMapper)
		{
			return ExecuteNonQuery(database, procedureName, parameterMapper, null);
		}


        /// <summary>
		/// Executes a query and returns the number of affected rows.
		/// </summary>
		/// <param name="database"></param>
		/// <param name="procedureName"></param>
		/// <param name="parameterValues"></param>
		/// <returns></returns>
		public static int ExecuteNonQuery(Database database, string procedureName, params object[] parameterValues)
		{
			int result = 0;

            try
            {
                using (SqlConnection connection = database.GetConnection())
                {
					SqlCommand command = CommandFactory.CreateCommand(connection, database.InstanceName, procedureName, parameterValues);

			
                	connection.Open();
                    result = command.ExecuteNonQuery();
                    connection.Close();
                }
            }
            catch (Exception e)
            {
                throw new SafeProcedureException(database, procedureName, e);
            }

			return result;
		}

        /// <summary>
        /// Executes a command and returns the value of the first column of the first row of the resultset (or null).
        /// </summary>
        /// <param name="database"></param>
        /// <param name="procedureName"></param>
        /// <param name="parameterMapper"></param>
        /// <returns></returns>
        public static object ExecuteScalar(Database database, string procedureName, ParameterMapper parameterMapper)
        {
			return ExecuteScalar(database, procedureName, parameterMapper, null);
        }

		/// <summary>
		/// 	<para>Executes a stored procedure on the specified database.</para>
		/// </summary>
		/// <param name="database">
		/// 	<para>The <see cref="Database"/> on which the sproc should be executed.</para>
		/// </param>
		/// <param name="procedureName">
		/// 	<para>The name of the sproc to execute.</para>
		/// </param>
		/// <param name="parameterMapper">
		/// 	<para>A delegate that will populate the parameters in the sproc call.
		/// 	Specify <see langword="null"/> if the sproc does not require parameters.</para>
		/// </param>
		/// <param name="outputMapper">
		/// 	<para>A delegate that will read the value of the parameters returned
		/// 	by the sproc call.  Specify <see langword="null"/> if no output parameters
		/// 	have been provided by the <paramref name="parameterMapper"/> delegate.</para>
		/// </param>
		/// <returns>
		/// 	<para>The value returned by as part of the result set.</para>
		/// </returns>
		/// <exception cref="ArgumentNullException">
		/// 	<para>The argument <paramref name="database"/> is <see langword="null"/>.</para>
		/// 	<para>-or-</para>
		/// 	<para>The argument <paramref name="procedureName"/> is <see langword="null"/>.</para>
		/// </exception>
		/// <exception cref="SafeProcedureException">
		/// 	<para>An unexpected exception has been encountered during the sproc call.</para>
		/// </exception>
		public static object ExecuteScalar(Database database, string procedureName, ParameterMapper parameterMapper, OutputParameterMapper outputMapper)
		{
			if (database == null) throw new ArgumentNullException("database");
			if (procedureName == null) throw new ArgumentNullException("procedureName");

			object result;

			try
			{
				using (SqlConnection connection = database.GetOpenConnection())
				{
					result = ExecuteScalar(database, connection, procedureName, parameterMapper, outputMapper);
				}
			}
			catch (SafeProcedureException)
			{
				throw;
			}
			catch (Exception e)
			{
				throw new SafeProcedureException(database, procedureName, e);
			}

			return result;
		}

		/// <summary>
		/// 	<para>Executes a stored procedure on the specified connection,
		///		that returns a single value in the result set.</para>
		/// </summary>
		/// <param name="database">
		/// 	<para>The <see cref="Database"/> to which the specified connection
		/// 	object belongs.  This object is for informational purposes only,
		/// 	and will not be used to create new connections.</para>
		/// </param>
		/// <param name="connection">
		/// 	<para>The <see cref="SqlConnection"/> on which to execute sproc.
		/// 	If this connection is not yet open, it will be opened and closed.  
		/// 	If this connection is already open, it will NOT be closed.  In this case,
		/// 	the caller is responsible for its disposal.</para>
		/// </param>
		/// <param name="procedureName">
		/// 	<para>The name of the sproc to execute.</para>
		/// </param>
		/// <param name="parameterMapper">
		/// 	<para>A delegate that will populate the parameters in the sproc call.
		/// 	Specify <see langword="null"/> if the sproc does not require parameters.</para>
		/// </param>
		/// <param name="outputMapper">
		/// 	<para>A delegate that will read the value of the parameters returned
		/// 	by the sproc call.  Specify <see langword="null"/> if no output parameters
		/// 	have been provided by the <paramref name="parameterMapper"/> delegate.</para>
		/// </param>
		/// <returns>
		/// 	<para>The value returned by as part of the result set.</para>
		/// </returns>
		/// <exception cref="ArgumentNullException">
		/// 	<para>The argument <paramref name="database"/> is <see langword="null"/>.</para>
		/// 	<para>-or-</para>
		/// 	<para>The argument <paramref name="connection"/> is <see langword="null"/>.</para>
		/// 	<para>-or-</para>
		/// 	<para>The argument <paramref name="procedureName"/> is <see langword="null"/>.</para>
		/// </exception>
		/// <exception cref="SafeProcedureException">
		/// 	<para>An unexpected exception has been encountered during the sproc call.</para>
		/// </exception>
		public static object ExecuteScalar(Database database, SqlConnection connection, string procedureName, ParameterMapper parameterMapper, OutputParameterMapper outputMapper)
		{
			if (database == null) throw new ArgumentNullException("database");
			if (connection == null) throw new ArgumentNullException("connection");
			if (procedureName == null) throw new ArgumentNullException("procedureName");

			object result;

			try
			{
				SqlCommand command = CommandFactory.CreateParameterMappedCommand(connection, procedureName, parameterMapper);

				bool doClose = false;
				if (connection.State != ConnectionState.Open)
				{
					doClose = true;
					connection.Open();
				}
				
				result = command.ExecuteScalar();

				if (doClose == true)
				{
					connection.Close();
				}

				if (outputMapper != null)
				{
					ParameterSet outputParams = new ParameterSet(command.Parameters);
					outputMapper(outputParams);
				}
			}
			catch (Exception e)
			{
				throw new SafeProcedureException(database, procedureName, e);
			}

			return result;
		}

		/// <summary>
		/// Executes a command and returns the value of the first column of the first row of the resultset (or null).
		/// </summary>
		/// <param name="database">The database.</param>
		/// <param name="procedureName">The stored procedure name.</param>
		/// <param name="parameterValues">The parameter values.</param>
		/// <returns></returns>
		public static object ExecuteScalar(Database database, string procedureName, params object[] parameterValues)
		{
            object result;

            try
            {
                using (SqlConnection connection = database.GetConnection())
                {
					SqlCommand command = CommandFactory.CreateCommand(connection, database.InstanceName, procedureName, parameterValues);

				
                	connection.Open();
                    result = command.ExecuteScalar();
                    connection.Close();
                }
            }
            catch (Exception e)
            {
                throw new SafeProcedureException(database, procedureName, e);
            }

            return result;
        }

        /// <summary>
        /// Executes a single-result procedure and loads the results into a DataTable named after the procedure.
        /// </summary>
        /// <param name="database"></param>
        /// <param name="procedureName"></param>
        /// <param name="parameters"></param>
        /// <returns>A fully populated datatable</returns>
        /// <remarks>Will throw an exception if one occurs, but will close database connection.</remarks>
        public static DataTable Execute(Database database, string procedureName, params object[] parameters)
        {
            DataTable dt;

            try
            {
                 dt = new DataTable(procedureName);

                using (IDataReader reader = Procedure.ExecuteReader(database, procedureName, parameters))
                {
                    dt.Load(reader, LoadOption.OverwriteChanges);
                }
            }
            catch (Core.Data.Exceptions.DataException) // Procedure class already wrapped all necessary data
            {
                throw;
            }
            catch (Exception e)
            {
                throw new SafeProcedureException(database, procedureName, e);
            }

            return dt;
        }

        /// <summary>
        /// Executes a single-result procedure and loads the results into a DataTable named after the procedure.
        /// </summary>
        /// <param name="database"></param>
        /// <param name="procedureName"></param>
        /// <param name="parameterMapper"></param>
        /// <returns>A fully populated datatable</returns>
        /// <remarks>Will throw an exception if one occurs, but will close database connection.</remarks>
        public static DataTable Execute(Database database, string procedureName, ParameterMapper parameterMapper)
        {
            DataTable dt;

            try
            {
                dt = new DataTable(procedureName);

                using (IDataReader reader = Procedure.ExecuteReader(database, procedureName, parameterMapper))
                {
                    dt.Load(reader, LoadOption.OverwriteChanges);
                }
            }
            catch (Core.Data.Exceptions.DataException) // Procedure class already wrapped all necessary data
            {
                throw;
            }
            catch (Exception e)
            {
                throw new SafeProcedureException( database, procedureName, e);
            }

            return dt;
        }


        /// <summary>
        /// Executes a procedure and allows the caller to inject a resultset mapper and an output parameter mapper.
        /// </summary>
        /// <param name="database"></param>
        /// <param name="procedureName"></param>
        /// <param name="parameterMapper"></param>
        /// <param name="result"></param>
		public static void ExecuteAndMapResults(Database database, string procedureName, StoredProcedureParameterList parameterList, ResultMapper result, OutputParameterMapper outputMapper)
        {
			try
			{
				using (SqlConnection connection = database.GetConnection())
				{
					SqlCommand command = CommandFactory.CreateCommand(connection, database.InstanceName, procedureName, parameterList);

				
					connection.Open();
					IRecordSet reader = new DataRecord(command.ExecuteReader(CommandBehavior.CloseConnection));
					result(reader);
					connection.Close();

					if (outputMapper != null)
						outputMapper(new ParameterSet(command.Parameters));
				}
			}
			catch (Exception e)
			{
				throw new SafeProcedureException(database, procedureName, e);
			}
        }

		/// <summary>
		/// Executes a procedure and allows the caller to inject a resultset mapper.
		/// </summary>
		/// <param name="database"></param>
		/// <param name="procedureName"></param>
		/// <param name="parameterMapper"></param>
		/// <param name="result"></param>
		public static void ExecuteAndMapResults(Database database, string procedureName, ParameterMapper parameterMapper, ResultMapper result)
		{
			try
			{
				using (IRecordSet reader = Procedure.Execute(database, procedureName, parameterMapper))
				{
					result(reader);
				}
			}
			catch (Core.Data.Exceptions.DataException) // Procedure class already wrapped all necessary data
			{
				throw;
			}
			catch (Exception e)
			{
				throw new SafeProcedureException(database, procedureName, e);
			}
		}

        /// <summary>
        /// Executes a procedure and allows the caller to inject a resultset mapper.
        /// </summary>
        /// <param name="database"></param>
        /// <param name="procedureName"></param>
        /// <param name="result"></param>
        /// <param name="parameters"></param>
        public static void ExecuteAndMapResults(Database database, string procedureName, ResultMapper result, params object[] parameters)
        {
            try
            {
          
                using (IRecordSet reader = Procedure.Execute(database, procedureName, parameters))
                {
                    result(reader);
                }
            }
            catch (Core.Data.Exceptions.DataException) // Procedure class already wrapped all necessary data
            {
                throw;
            }
            catch (Exception e)
            {
                throw new SafeProcedureException( database, procedureName, e);
            }
        }

        /// <summary>
        /// Executes a single-result procedure and fires a mapping delegate for each row that is returned.
        /// </summary>
        /// <param name="database"></param>
        /// <param name="procedureName"></param>
        /// <param name="parameterMapper"></param>
        /// <param name="recordMapper"></param>
        public static void ExecuteAndMapRecords(Database database, string procedureName, ParameterMapper parameterMapper, RecordMapper recordMapper)
        {
            try
            {
                using (IRecordSet reader = Procedure.Execute(database, procedureName, parameterMapper))
                {
                    while (reader.Read())
                        recordMapper(reader);
                }
            }
            catch (Exception e)
            {
                throw new SafeProcedureException( database, procedureName, e);
            }
        }
		/// <summary>
		/// Executes a single-result procedure and fires a mapping delegate for each row that is returned and then fires a parameter mapping delegate for output params.
		/// </summary>
		/// <param name="database"></param>
		/// <param name="procedureName"></param>
		/// <param name="parameterMapper"></param>
		/// <param name="recordMapper"></param>
		/// <param name="outputMapper"></param>
		public static void ExecuteAndMapRecords(Database database, string procedureName, ParameterMapper parameterMapper, RecordMapper recordMapper, OutputParameterMapper outputMapper)
		{
			try
			{
				using ( SqlConnection connection = database.GetConnection() )
				{
					SqlCommand command = CommandFactory.CreateParameterMappedCommand(connection, procedureName, parameterMapper);

	
					connection.Open();
					IRecordSet reader = new DataRecord(command.ExecuteReader(CommandBehavior.CloseConnection));
					while ( reader.Read() )
						recordMapper(reader);
					connection.Close();

					if ( outputMapper != null )
						outputMapper(new ParameterSet(command.Parameters));
				}
			}
			catch ( Exception e )
			{
				throw new SafeProcedureException(database, procedureName, e);
			}
		}

        /// <summary>
        /// Executes a single-result procedure and fires a mapping delegate for each row that is returned.
        /// </summary>
        /// <param name="database"></param>
        /// <param name="procedureName"></param>
        /// <param name="recordMapper"></param>
        /// <param name="parameters"></param>
        public static void ExecuteAndMapRecords(Database database, string procedureName, RecordMapper recordMapper, params object[] parameters)
        {
            try
            {
        
                using (IRecordSet reader = Procedure.Execute(database, procedureName, parameters))
                {
                    while (reader.Read())
                        recordMapper(reader);
                }
            }
            catch (Core.Data.Exceptions.DataException) // Procedure class already wrapped all necessary data
            {
                throw;
            }
            catch (Exception e)
            {
                throw new SafeProcedureException( database, procedureName, e);
            }
        }

		/// <summary>
		/// Executes a procedure and fires a mapping delegate and hydrates the T instance
		/// </summary>
		/// <typeparam name="T"></typeparam>
		/// <param name="objectInstance"></param>
		/// <param name="database"></param>
		/// <param name="procedureName"></param>
		/// <param name="recordMapper"></param>
		/// <param name="parameters"></param>
		public static bool ExecuteAndHydrateInstance<T>(T objectInstance, Database database, string procedureName, RecordMapper<T> recordMapper, params object[] parameters)
		{
			bool result = false;
            try
            {
    
                using ( IRecordSet reader = Procedure.Execute(database, procedureName, parameters) )
                {
					if ( reader.Read() )
					{
						recordMapper(reader, objectInstance);
						result = true;
					
					}
                }
            }
            catch (Core.Data.Exceptions.DataException) // Procedure class already wrapped all necessary data
            {
                throw;
            }
            catch (Exception e)
            {
                throw new SafeProcedureException(database, procedureName, typeof(T), e);
            }
			return result;
		}

		/// <summary>
		/// Executes a procedure and fires a mapping delegate and hydrates the T instance
		/// </summary>
		/// <typeparam name="T"></typeparam>
		/// <param name="objectInstance"></param>
		/// <param name="database"></param>
		/// <param name="procedureName"></param>
		/// <param name="recordMapper"></param>
		/// <param name="parameters"></param>
		public static bool ExecuteAndHydrateInstance<T>(T objectInstance, Database database, string procedureName, RecordMapper recordMapper, params object[] parameters)
		{
			return ExecuteAndHydrateInstance<T>(objectInstance, database, procedureName,
				delegate(IRecord reader, T instance)
				{
					recordMapper(reader);
				}, parameters);
		}

		/// <summary>
		/// Creates a new T instance, executes a procedure and fires a mapping delegate and returns the T instance
		/// </summary>
		/// <typeparam name="T"></typeparam>
		/// <param name="database"></param>
		/// <param name="procedureName"></param>
		/// <param name="recordMapper"></param>
		/// <param name="parameters"></param>
		/// <returns></returns>
		public static T ExecuteAndGetInstance<T>(Database database, string procedureName, RecordMapper<T> recordMapper, params object[] parameters) where T : new()
		{
            T objectInstance = new T();
			if ( !ExecuteAndHydrateInstance(objectInstance, database, procedureName, recordMapper, parameters) )
				return default(T);

            return objectInstance;
		}

		/// <summary>
		/// Executes a procedure and for each row returned creates a T instance, fires a mapping delegate and add the instance to the return List.
		/// </summary>
		/// <typeparam name="T"></typeparam>
		/// <param name="database"></param>
		/// <param name="procedureName"></param>
		/// <param name="recordMapper"></param>
		/// <param name="parameters"></param>
		/// <returns></returns>
		public static List<T> ExecuteAndGetInstanceList<T>(Database database, string procedureName, RecordMapper<T> recordMapper, params object[] parameters) where T : new()
		{
            List<T> instanceList = new List<T>();
            ExecuteAndHydrateInstanceList(instanceList, database, procedureName, recordMapper, parameters);
            return instanceList;
		}

		/// <summary>
		/// Executes a procedure and for each row returned creates a T instance, fires a mapping delegate and add the instance to a List.
		/// </summary>
		/// <typeparam name="T"></typeparam>
		/// <param name="instanceList"></param>
		/// <param name="database"></param>
		/// <param name="procedureName"></param>
		/// <param name="recordMapper"></param>
		/// <param name="parameters"></param>
        public static void ExecuteAndHydrateInstanceList<T>(List<T> instanceList, Database database, string procedureName, RecordMapper<T> recordMapper, params object[] parameters) where T : new()
        {
            try
            {
         
                using (IRecordSet reader = Procedure.Execute(database, procedureName, parameters))
                {
                    while (reader.Read())
                    {
                        T objectInstance = new T();
                        recordMapper(reader, objectInstance);
                        instanceList.Add(objectInstance);
						
                    }
                }
            }
            catch (Core.Data.Exceptions.DataException) // Procedure class already wrapped all necessary data
            {
                throw;
            }
            catch (Exception e)
            {
                throw new SafeProcedureException(database, procedureName, typeof(T), e);
            }
        }

		/// <summary>
		/// Executes a procedure that one or more multiple recordsets and for each row returned in each record set, call the delegates
		/// in the delegate array to map the generic entity type
		/// </summary>
		/// <typeparam name="T">any T type with a default construtor</typeparam>
		/// <param name="objectInstance">The generic entity instance to be hydrated</param>
		/// <param name="database">The database to retrieve the data from if neccesary.</param>
		/// <param name="procedureName">The name of the stored procedure to execute.</param>
		/// <param name="recordMappers">The array of mapping delegates with parameter IRecord used to populate the generic entity instance from the DataReader.</param>
		/// <param name="parameters">The paramters values used in the stored procedure.</param>
		/// <returns>An instance of EntityList containing the data retrieved from the database.</returns>
		public static void ExecuteAndHydrateGenericInstance<T>(T objectInstance, Database database, string procedureName, RecordMapper<T>[] recordMappers, params object[] parameters) 
			where T: new()
		{
			try
			{
				
				using (IRecordSet reader = Procedure.Execute(database, procedureName, parameters))
				{
					//Get all the recordsets, call each delegate in the delegate array to map the generic entity instance.
					//Note that if the number of delegates in the array does not match up with the number of recordsets returned
					//the function exit normally, it will only call the delegates that are in the array.
					int mapperIndex = 0;
					do
					{
						if (mapperIndex < recordMappers.Length)
						{
							while (reader.Read())
							{
								recordMappers[mapperIndex](reader, objectInstance);
							}
							mapperIndex++;
						}
						else
						{
							break;
						}
					} while (reader.NextResult());
				
				}
			}
			catch (Core.Data.Exceptions.DataException) // Procedure class already wrapped all necessary data
			{
				throw;
			}
			catch (Exception e)
			{
				throw new SafeProcedureException(database, procedureName, typeof(T), e);
			}
		}

		/// <summary>
		/// Executes a procedure and for each row returned creates a T instance, fires a mapping delegate and add the instance to a List.
		/// </summary>
		/// <typeparam name="T"></typeparam>
		/// <param name="instanceList"></param>
		/// <param name="database"></param>
		/// <param name="procedureName"></param>
		/// <param name="recordMapper"></param>
		/// <param name="parameters"></param>
		public static void ExecuteAndHydrateInstanceList<T>(List<T> instanceList, Database database, string procedureName, RecordMapper recordMapper, params object[] parameters) where T : new()
		{
            try
            {
          
                using (IRecordSet reader = Procedure.Execute(database, procedureName, parameters))
                {
                    while (reader.Read())
                    {
                        T objectInstance = new T();
                        recordMapper(reader);
                        instanceList.Add(objectInstance);
					
                    }
                }
            }
            catch (Core.Data.Exceptions.DataException) // Procedure class already wrapped all necessary data
            {
                throw;
            }
            catch (Exception e)
            {
                throw new SafeProcedureException(database, procedureName, typeof(T), e);
            }
		}

		/// <summary>
		/// Executes a procedure and for each row returned creates a T instance, fires a mapping delegate and adds the instance to a dictionary.  First column returned must be the int key.
		/// </summary>
		/// <typeparam name="T"></typeparam>
		/// <param name="database"></param>
		/// <param name="procedureName"></param>
		/// <param name="recordMapper"></param>
		/// <param name="parameters"></param>
		/// <returns></returns>
		public static Dictionary<int, T> ExecuteAndGetDictionary<T>(Database database, string procedureName, RecordMapper<T> recordMapper, params object[] parameters) where T : new()
		{
			try
			{
			
				Dictionary<int, T> dictionaryList = new Dictionary<int, T>();
				
				using ( IRecordSet reader = Procedure.Execute(database, procedureName, parameters) )
				{
					while ( reader.Read() )
					{
						T objectInstance = new T();
						recordMapper(reader, objectInstance);
						dictionaryList[reader.GetInt32(0)] = objectInstance;
					
					}
				}

				return dictionaryList;
			}
			catch ( Core.Data.Exceptions.DataException ) // Procedure class already wrapped all necessary data
			{
				throw;
			}
			catch (Exception e)
            {
                throw new SafeProcedureException(database, procedureName, typeof(T), e);
            }
		}



    }
}
