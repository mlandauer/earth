// $Id$ 

class SpTester
{
	public:
		SpTester(string className);
		static void finish();
		static void setVerbose(bool v) { verbose = v; };
		static void setFloatDelta(float d) { floatDelta = d; };
		static float getFloatDelta() { return floatDelta; };
		virtual void test() = 0;
	protected:
		bool checkEqual(string testName, string a, string b);
		bool checkEqual(string testName, int a, int b);
		bool checkEqual(string testName, float a, float b);
		bool checkEqual(string testName, float a, float b, float delta);
		bool check(string testName, bool a);
		bool checkNULL(string testName, void *p);
		bool checkNotNULL(string testName, void *p);
		void failMessage(string testName);
		void successMessage(string testName);
	private:
		static bool verbose;
		static int noErrors;
		static float floatDelta;
		string name;
};

